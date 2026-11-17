#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo 'Run this bootstrap as root on Ubuntu 22.04 or 24.04.' >&2
  exit 1
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl gnupg rsync nginx python3 python3-venv python3-pip openjdk-21-jre

install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key -o /etc/apt/keyrings/jenkins-keyring.asc
chmod 0644 /etc/apt/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get update
apt-get install -y jenkins nodejs
npm install --global pm2

getent group tutedude-deploy >/dev/null || groupadd --system tutedude-deploy
id tutedude >/dev/null 2>&1 || useradd --system --create-home --shell /usr/sbin/nologin tutedude
usermod -aG tutedude-deploy jenkins
usermod -aG tutedude-deploy tutedude
install -d -o tutedude -g tutedude-deploy -m 2775 /opt/tutedude/flask /opt/tutedude/express

install -o root -g root -m 0755 "$repo_dir/deployment/scripts/tutedude-deploy-flask" /usr/local/sbin/tutedude-deploy-flask
install -o root -g root -m 0755 "$repo_dir/deployment/scripts/tutedude-deploy-express" /usr/local/sbin/tutedude-deploy-express
install -o root -g root -m 0644 "$repo_dir/deployment/systemd/tutedude-flask.service" /etc/systemd/system/tutedude-flask.service
install -o root -g root -m 0644 "$repo_dir/deployment/systemd/tutedude-pm2.service" /etc/systemd/system/tutedude-pm2.service
install -o root -g root -m 0644 "$repo_dir/deployment/nginx/tutedude.conf" /etc/nginx/sites-available/tutedude
ln -sfn /etc/nginx/sites-available/tutedude /etc/nginx/sites-enabled/tutedude
rm -f /etc/nginx/sites-enabled/default

cat > /etc/sudoers.d/jenkins-tutedude <<'SUDOERS'
jenkins ALL=(root) NOPASSWD: /usr/local/sbin/tutedude-deploy-flask *, /usr/local/sbin/tutedude-deploy-express *
SUDOERS
chmod 0440 /etc/sudoers.d/jenkins-tutedude
visudo -cf /etc/sudoers.d/jenkins-tutedude

systemctl daemon-reload
systemctl enable jenkins nginx tutedude-flask tutedude-pm2
systemctl restart jenkins nginx
echo 'Host bootstrap complete. Run a Jenkins job to deploy the apps, then verify both services and the public HTTP URL.'
