# EC2 deployment and Jenkins setup

The reviewer asked for one public EC2 host running Flask, Express, Jenkins and GitHub-triggered pipelines. This directory contains the Ubuntu bootstrap, systemd unit, PM2 ecosystem file, restricted Jenkins deploy helpers, and Nginx reverse proxy. The bootstrap does not create AWS resources; it runs on an Ubuntu 22.04 or 24.04 host after the instance and security group have been created.

## Host requirements

- Ubuntu 22.04 or 24.04 EC2 instance with a public IPv4 address.
- Security group: TCP 80 from the public internet; TCP 22 only from the administrator’s `/32`; do not expose Jenkins port 8080 publicly. Restrict Jenkins administration to an SSH tunnel.
- An SSH key configured for the instance and AWS costs reviewed before launch.

## Bootstrap

Clone `https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins.git` on the EC2 instance, then run:

```bash
cd tutedude-assignment-9
sudo bash deployment/bootstrap-ubuntu.sh
```

The script installs Jenkins LTS, Java 21, Python, Node.js 20, PM2, Nginx and the application service configuration. It adds two restricted root-owned deployment helpers and grants the Jenkins service account only those helpers through sudoers. Review the script and cost/security configuration before running it.

## Jenkins

Open Jenkins locally through an SSH tunnel (`ssh -L 8080:127.0.0.1:8080 ubuntu@EC2_PUBLIC_IP`), complete the setup wizard, and install the plugins listed in `jenkins/plugins.txt`. Create a Pipeline job against the assignment repository with script path `Jenkinsfile`; for separate app jobs use `Jenkinsfile.flask` and `Jenkinsfile.express`. Configure the GitHub server webhook secret in Jenkins credentials and the GitHub plugin configuration; do not put the secret in Git. The webhook URL is `http://EC2_PUBLIC_IP/github-webhook/`; Nginx exposes only that endpoint to GitHub while port 8080 stays private.

The pipeline installs dependencies, validates both apps, runs the restricted deployment helpers, restarts Flask under systemd and Express under PM2, then checks the health endpoint. Nginx serves the frontend on port 80 and forwards `/github-webhook/` to Jenkins.

## Verify and stop

```bash
sudo systemctl status jenkins nginx tutedude-flask tutedude-pm2 --no-pager
curl --fail http://EC2_PUBLIC_IP/api/health
```

To stop the EC2 instance and avoid ongoing compute charges, stop or terminate it in the AWS console after capturing required evidence. A stopped instance can still incur charges for attached storage and reserved public IPs.
