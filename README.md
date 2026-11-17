# Assignment 9 Jenkins CI/CD

**Repository:** https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins

## What the reviewer asked to see

The feedback requested root-level Jenkinsfiles, Flask under systemd, Express under PM2, both apps on an EC2 public IP, a Jenkins controller with plugins, GitHub webhooks, and screenshots/build evidence. The main pipeline is now visible at the repository root as `Jenkinsfile`; `Jenkinsfile.flask` and `Jenkinsfile.express` define separate app pipelines. `Jenkinsfile.local` runs the same source through a local Docker Compose deployment for a reproducible non-AWS CI run.

The EC2 package is under `deployment/`: Ubuntu bootstrap, systemd/PM2 units, Nginx routing, restricted deployment helpers and detailed setup instructions. Jenkins plugin names are listed in `jenkins/plugins.txt`. The top-level pipelines deploy from a Jenkins workspace on the EC2 host and verify health checks. The local pipeline publishes the demo at `http://localhost:3100`.

## Current verification status

The source, pipeline definitions and deployment scripts are included. The local run will be recorded in `evidence/` once Jenkins is installed and the pipeline succeeds. AWS currently has zero EC2 instances in `ap-southeast-2`; CloudShell reports account verification in progress. No public EC2 IP, remote Jenkins build, GitHub webhook delivery, or live screenshot is claimed unless it is actually captured. An EC2 deployment incurs usage charges; the bootstrap does not create AWS resources.

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

See [`deployment/README.md`](deployment/README.md) for EC2 setup and safe Jenkins/webhook access instructions.
