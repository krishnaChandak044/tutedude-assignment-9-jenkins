# Assignment 9 deployment runbook

This guide describes how to deploy the Flask API and Express web app to one Ubuntu EC2 instance and connect Jenkins to GitHub push events. It is designed to be executable in order, with verification points and a teardown checklist.

> **Current state (2026-11-25):** EC2 instance `i-02064e2837ce19769` is running Ubuntu 24.04 in `ap-southeast-2` on `t3.small`, with 20 GiB gp3 storage and public IPv4 `13.211.139.18`. The public app responds with HTTP 200; Flask readiness, Express-to-Flask health, and active systemd services have been verified. Jenkins is installed and bound to loopback port 8080. Jenkins initial setup, job creation, successful builds, GitHub webhook delivery, and evidence screenshots are still outstanding. `../evidence/aws-verification-blocker.png` records the earlier CloudShell verification error and is historical context only.

## 1. What the deployment will create

- One Ubuntu 22.04 or 24.04 EC2 instance with at least 20 GiB gp3 storage. Jenkins, Python/Flask, Node/Express, PM2, and Nginx share this host.
- Nginx listens on public TCP 80. It sends `/` and `/api/health` to Express on loopback port 3000 and sends only `/github-webhook/` to Jenkins on loopback port 8080.
- Flask listens on loopback port 5000. Express calls Flask using `API_URL=http://127.0.0.1:5000`.
- Jenkins listens on loopback port 8080. Administrators reach its UI over an SSH tunnel; the EC2 security group does not expose 8080.
- Jenkins jobs check out the repository, install dependencies, validate the code, deploy through two root-owned helper scripts, restart services, and check health endpoints.

The current host topology is in [`../architecture-deployed.svg`](../architecture-deployed.svg); dashed paths are still pending Jenkins job and webhook verification. `architecture-target.png` is the original target design. Names marked `PUBLIC_IP` below are placeholders; replace them with the instance's current public IPv4 address.

## 2. Before provisioning

1. The account can launch EC2 even though CloudShell previously displayed an account-verification error. The live instance is already running; use its current details rather than the old blocker screenshot.
2. Review the assignment's budget limit (previously authorized up to **US$20 total**) in the [AWS Pricing Calculator](https://calculator.aws/#/) for the selected region and expected run time. Instance, EBS volume, public IPv4, data transfer, and region affect cost. AWS Budget notifications are alerts, not a hard spending cap; set alerts below the cap and terminate resources promptly after evidence collection. See [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/bcm-lite-use-budget.html).
3. Have repository access to `https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins`, an SSH key pair, and the public IPv4 address from which you will administer SSH.
4. Choose a region and an Ubuntu 22.04 or 24.04 LTS AMI. The assignment review recommended at least 20 GiB disk. Choose an instance size with enough RAM for Jenkins and both apps; check current region pricing and Jenkins' current requirements before launch. The earlier local Jenkins attempt went offline when free disk space was under 1 GiB, so leave comfortable free disk space and monitor it.

## 3. Create the EC2 instance and restrict network access

The deployed instance was launched with:

- Ubuntu Server 24.04 LTS AMI `ami-048c1a9eb63a67eed`, `t3.small` (2 vCPU, 2 GiB RAM), in `ap-southeast-2`.
- A 20 GiB gp3 root volume.
- A key pair you control. Download the private key once and keep it private; never put it in Git, the ZIP, a screenshot, or a Jenkins log.
- A security group with these inbound rules only:

| Port | Source | Purpose |
| --- | --- | --- |
| TCP 22 | Administrator's current public IPv4 `/32` (set at launch and update if it changes) | SSH and the Jenkins SSH tunnel |
| TCP 80 | `0.0.0.0/0` (and `::/0` only if IPv6 is enabled) | Public app and GitHub webhook endpoint |

Do **not** add inbound TCP 8080 or 3000 or 5000. The deployment config binds Jenkins and both apps to loopback; Nginx is the public entry point. AWS recommends limiting SSH source addresses to the administrator's known IP range; see [EC2 security group guidance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-security-group.html). Use a stable public IPv4 if the console offers one and include its cost in the budget check. Record the instance ID, region, public IPv4, AMI, and launch time for the report, but redact account IDs from public screenshots.

## 4. Connect and install the host configuration

On the administrator's computer, restrict the key file and connect (substitute the actual key path and IP):

```bash
chmod 400 ~/Downloads/assignment-key.pem
ssh -i ~/Downloads/assignment-key.pem ubuntu@PUBLIC_IP
```

The live host has already been bootstrapped from the submitted project. To reproduce the setup on another instance, use:

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins.git
cd tutedude-assignment-9-jenkins
sudo bash deployment/bootstrap-ubuntu.sh
```

The bootstrap installs Java 21, Jenkins LTS, Python tooling, Node.js 20, PM2, Nginx, app service units, deployment helpers, and a constrained sudoers rule. It does **not** create AWS resources, register a webhook, or run a pipeline. It uses Jenkins' 2026 repository signing key. Express is supervised by `pm2-runtime` in foreground mode through systemd. After it completes, inspect installation and service state:

```bash
sudo tail -n 100 /var/log/cloud-init-output.log
sudo systemctl status jenkins nginx --no-pager
sudo nginx -t
sudo ss -lntp
```

Expected listeners are Nginx on public port 80 and Jenkins/Express/Flask on loopback ports 8080/3000/5000. Do not continue until Nginx configuration is valid and Jenkins is active. The app services may remain inactive until the first successful pipeline deploys them.

## 5. Finish Jenkins setup without publishing its admin UI

From a local terminal, open an SSH tunnel in a dedicated terminal and leave it running:

```bash
ssh -i ~/Downloads/assignment-key.pem -N -L 8080:127.0.0.1:8080 ubuntu@PUBLIC_IP
```

Open `http://127.0.0.1:8080` on that same computer. Retrieve the one-time setup password on the EC2 SSH session:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Complete the unlock wizard, create a named administrator, and install the plugins in [`../jenkins/plugins.txt`](../jenkins/plugins.txt). At minimum, confirm Pipeline, Git, and GitHub plugins are installed. Keep port 8080 out of the security group. Jenkins is installed on the live host, but this initial setup and job creation remain pending. Create a Pipeline job named `tutedude-cicd`:

1. Select **Pipeline script from SCM**, SCM **Git**, and set the repository URL to `https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins.git`.
2. If the repository is public, no checkout credential is needed. If private, add a Jenkins credential with the least permissions needed; select it in the job. Do not place a token in the Jenkinsfile or the ZIP.
3. Set the branch to the actual default branch (`*/main` if the repository uses `main`). Set **Script Path** to `Jenkinsfile`.
4. Save. The root Jenkinsfile defines `githubPush()` and deploys both apps. For individual jobs, create two additional Pipeline-from-SCM jobs with script paths `Jenkinsfile.flask` and `Jenkinsfile.express`; do not point to older nested Jenkinsfiles.

If the node is offline, check free storage and memory before running a build:

```bash
df -h /
free -h
sudo journalctl -u jenkins -n 100 --no-pager
```

Add storage or choose a suitable host size if the controller/agent cannot start. The local controller log in this ZIP records an earlier offline-node condition; it is not evidence of an EC2 run.

## 6. Configure the GitHub push webhook

This package uses the Jenkins GitHub plugin's manual webhook mode. In the GitHub repository, open **Settings → Webhooks → Add webhook**:

- **Payload URL:** `http://PUBLIC_IP/github-webhook/` (keep the trailing slash; use HTTPS with a valid certificate if a domain/TLS endpoint is available).
- **Content type:** `application/json`.
- **Secret:** leave blank for this documented HTTP exercise unless you separately configure and verify a supported signature-validation method end to end. Do not invent a Jenkins credential or claim signature verification that has not been configured.
- **Events:** choose **Just the push event**.
- Check **Active**, add the webhook, and use the delivery history's **Redeliver**/test function if available.

The Nginx config forwards only the exact `/github-webhook/` route to loopback Jenkins. GitHub should show a successful 2xx delivery. Then push a small commit to the configured branch and confirm that the Jenkins job starts without pressing **Build Now**. Verify the webhook delivery and the corresponding Jenkins run; a saved webhook configuration alone is not proof that the integration works.

Authoritative references: [Jenkins GitHub plugin](https://plugins.jenkins.io/github/), [GitHub testing webhooks](https://docs.github.com/en/webhooks/testing-and-troubleshooting-webhooks/testing-webhooks), and [GitHub webhook troubleshooting](https://docs.github.com/en/webhooks/testing-and-troubleshooting-webhooks/troubleshooting-webhooks).

## 7. Run and verify both pipelines

The root `Jenkinsfile` is the combined pipeline. It has not run yet. After creating the job, trigger it once manually for initial validation, then verify a push-triggered run. It checks out the source, installs Python and Node dependencies, performs syntax checks, invokes the limited deployment helpers, and checks the public-facing health route. For separate jobs, use the root `Jenkinsfile.flask` and `Jenkinsfile.express` script paths.

On EC2, verify the service managers and loopback endpoints:

```bash
sudo systemctl is-active jenkins nginx tutedude-flask tutedude-pm2
sudo systemctl status tutedude-pm2 --no-pager
sudo journalctl -u tutedude-pm2 -n 30 --no-pager
curl --fail --show-error http://127.0.0.1:5000/api/health
curl --fail --show-error http://127.0.0.1:5000/api/ready
curl --fail --show-error http://127.0.0.1:3000/api/health
sudo nginx -t
```

From outside EC2, verify the app through Nginx:

```bash
curl --fail --show-error http://PUBLIC_IP/
curl --fail --show-error http://PUBLIC_IP/api/health
```

The browser should render the Express page at `http://PUBLIC_IP/`; `/api/health` should return JSON with `status: ok` and `service: flask-backend`. Capture the Jenkins console output and confirm both deploy stages and the health-check stage completed successfully. Preserve the build number, timestamp, and commit SHA in notes.

Useful diagnostics:

```bash
sudo journalctl -u tutedude-flask -n 100 --no-pager
sudo journalctl -u tutedude-pm2 -n 100 --no-pager
sudo journalctl -u nginx -n 100 --no-pager
sudo journalctl -u jenkins -n 100 --no-pager
sudo tail -n 100 /var/log/nginx/error.log
```

## 8. Evidence checklist for the resubmission

Capture real screenshots only after each state exists. Save dated originals in `evidence/`, use names listed in [`../evidence/README.md`](../evidence/README.md), and redact private keys, passwords, tokens, webhook secret, and full AWS account identifiers.

1. EC2 instance details showing **running** state, region, and public IPv4 (redact account ID).
2. Browser showing the Express page loaded from the EC2 public IP.
3. Browser or terminal showing `/api/health` JSON from the same public IP.
4. EC2 terminal showing active `tutedude-flask`, `tutedude-pm2`, `nginx`, and `jenkins` services, plus PM2 status.
5. Jenkins dashboard showing a successful build number and console output for the combined pipeline or both separate pipelines.
6. GitHub webhook page showing the successful push delivery (2xx) and the corresponding push-triggered Jenkins build.
7. Include `architecture-deployed.svg` as the actual topology diagram. Update its pending-path labels only after the Jenkins job and webhook-triggered runs have been verified.

The supplied `aws-verification-blocker.png` is historical evidence of the earlier CloudShell verification message. It cannot substitute for the live deployment proofs above.

## 9. Troubleshooting

| Symptom | Check / next action |
| --- | --- |
| CloudShell reports verification pending | EC2 may still be usable. The current host was launched from the EC2 console; use SSH or the console rather than treating the CloudShell message as an EC2 blocker. |
| SSH times out | Confirm instance is running, the correct key/user (`ubuntu`) is used, and the security group's TCP 22 source matches your current public IP `/32`. |
| Jenkins is unavailable through tunnel | Confirm `systemctl status jenkins`, tunnel is still running, and `ss -lntp` shows Jenkins on loopback 8080. Never solve this by opening 8080 publicly. |
| Jenkins agent is offline | Inspect `df -h /`, `free -h`, and `journalctl -u jenkins`; increase available host resources and restart Jenkins if necessary. |
| App deployment fails | Read Jenkins console output and the relevant `journalctl` entries; check that the bootstrap ran and helper scripts exist under `/usr/local/sbin/`. |
| Flask fails to start | Check `/opt/tutedude/flask/requirements.txt`, Gunicorn install, `systemctl status tutedude-flask`, and the 5000 loopback health endpoint. |
| PM2 Runtime app fails | Inspect `systemctl status tutedude-pm2` and `journalctl -u tutedude-pm2`; confirm the installed unit uses `pm2-runtime` and that the ecosystem config points to `/opt/tutedude/express/server.js`. |
| GitHub delivery fails or returns 404 | Confirm exact URL including `/github-webhook/`, Nginx `location = /github-webhook/`, `sudo nginx -t`, port 80 reachability, and Jenkins GitHub plugin. |
| Delivery is 2xx but no build starts | Confirm job uses Pipeline-from-SCM, the root Jenkinsfile has `githubPush()`, branch/repository match, and inspect Jenkins logs and GitHub delivery details. |
| Public health check returns 502 | Check Express and Flask services, `API_URL=http://127.0.0.1:5000`, loopback health checks, and Nginx/Express logs. |

## 10. Stop resources and control costs

After the evidence is collected, terminate the EC2 instance if it is no longer needed. Stopping alone can leave EBS storage and some public IP charges. Also review and delete any unused snapshots, volumes, Elastic IPs, load balancers, or other created resources. Confirm the instance no longer appears as running and review AWS billing/cost explorer later. Record actual usage against the previously authorized US$20 ceiling; budget alerts are not an automatic stop mechanism.

## 11. Included configuration map

- `../Jenkinsfile` — combined deployment pipeline.
- `../Jenkinsfile.flask`, `../Jenkinsfile.express` — individual pipelines.
- `../jenkins/plugins.txt` — plugin IDs for setup.
- `bootstrap-ubuntu.sh` — host package installation and service wiring.
- `scripts/tutedude-deploy-flask`, `scripts/tutedude-deploy-express` — constrained deployment entry points invoked by Jenkins.
- `systemd/tutedude-flask.service`, `systemd/tutedude-pm2.service` — persistent process services.
- `pm2/ecosystem.config.cjs` — Express process configuration.
- `nginx/tutedude.conf` — public app and webhook routes.
- `../evidence/` — actual local logs plus the AWS verification blocker screenshot; add the live items in section 8 after deployment.

See [`../SUBMISSION_MANIFEST.md`](../SUBMISSION_MANIFEST.md) for the ZIP's exact file paths and the installed destinations.
