# Assignment 9 Jenkins CI/CD

**Repository:** https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins

The portal ZIP is named `Jenkins_CICD_Krishna.zip` and contains one top-level folder named `Jenkins_CICD_Krishna/`, as required by the assignment instructions.

For the exact archive paths and the paths where the bootstrap installs the deployment files, see [`SUBMISSION_MANIFEST.md`](SUBMISSION_MANIFEST.md).

The target architecture diagram is in [`architecture-target.png`](architecture-target.png). It describes the intended setup and is labeled as not deployed; it is not live deployment evidence.

## What the reviewer asked to see

The feedback requested root-level Jenkinsfiles, Flask under systemd, Express under PM2, both apps on an EC2 public IP, a Jenkins controller with plugins, GitHub webhooks, and screenshots/build evidence. The main pipeline is now visible at the repository root as `Jenkinsfile`; `Jenkinsfile.flask` and `Jenkinsfile.express` define separate app pipelines. `Jenkinsfile.local` runs the same source through a local Docker Compose deployment for a reproducible non-AWS CI run.

The EC2 package is under `deployment/`: Ubuntu bootstrap, systemd/PM2 units, Nginx routing, restricted deployment helpers and detailed setup instructions. Jenkins plugin names are listed in `jenkins/plugins.txt`. The EC2 Jenkins controller has separate `tutedude-flask` and `tutedude-express` jobs configured from `Jenkinsfile.flask` and `Jenkinsfile.express`. The GitHub push webhook targets `/github-webhook/`; both pipelines deploy from Jenkins workspaces on the EC2 host and verify health checks. `Jenkinsfile.local` defines a local Compose deployment at `http://localhost:3100`, but has not been run.

## Current verification status

The assignment is now deployed to Ubuntu 24.04 on EC2 instance `i-02064e2837ce19769` in `ap-southeast-2` (`t3.small`, 20 GiB gp3, public IPv4 `13.211.139.18`). Nginx serves the Express app on public port 80; Flask runs under systemd on loopback port 5000; Express runs under PM2 Runtime managed by systemd on loopback port 3000. Jenkins 2.580.2 is active on loopback port 8080. SSH is restricted to the current IPv4 `/32`, and Jenkins administration is not publicly exposed.

Live checks have returned HTTP 200 for the public app, Flask readiness JSON `{"ready":true}`, and the backend health JSON through Express and Nginx. `systemd` reports Jenkins, Nginx, Flask, and the PM2 Runtime service active. The first host bootstrap needed the current Jenkins 2026 signing key; the bootstrap now uses that key. Express uses `pm2-runtime` in foreground mode because the background PM2 daemon could not spawn on this host.

Jenkins initial setup and the Pipeline job are still pending. No Jenkins build, GitHub webhook delivery, or push-triggered deployment is claimed yet. Add the corresponding real screenshots and build logs to `evidence/` after those steps complete. The public IPv4 may change if the instance is stopped and started.

[`architecture-deployed.svg`](architecture-deployed.svg) diagrams the verified EC2 services and marks the Jenkins job and GitHub webhook path as pending until those are exercised.

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

See [`deployment/README.md`](deployment/README.md) for the full ordered EC2, Jenkins, webhook, verification, troubleshooting, evidence, and teardown runbook. It also documents the actual AWS account-verification blocker captured in `evidence/aws-verification-blocker.png`.
