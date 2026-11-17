# Assignment 9 Jenkins CI/CD

**Repository:** https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins

The portal ZIP is named `Jenkins_CICD_Krishna.zip` and contains one top-level folder named `Jenkins_CICD_Krishna/`, as required by the assignment instructions.

For the exact archive paths and the paths where the bootstrap installs the deployment files, see [`SUBMISSION_MANIFEST.md`](SUBMISSION_MANIFEST.md).

## What the reviewer asked to see

The feedback requested root-level Jenkinsfiles, Flask under systemd, Express under PM2, both apps on an EC2 public IP, a Jenkins controller with plugins, GitHub webhooks, and screenshots/build evidence. The main pipeline is now visible at the repository root as `Jenkinsfile`; `Jenkinsfile.flask` and `Jenkinsfile.express` define separate app pipelines. `Jenkinsfile.local` runs the same source through a local Docker Compose deployment for a reproducible non-AWS CI run.

The EC2 package is under `deployment/`: Ubuntu bootstrap, systemd/PM2 units, Nginx routing, restricted deployment helpers and detailed setup instructions. Jenkins plugin names are listed in `jenkins/plugins.txt`. The top-level pipelines are configured to deploy from a Jenkins workspace on the EC2 host and verify health checks. `Jenkinsfile.local` defines a local Compose deployment at `http://localhost:3100`, but has not been run.

## Current verification status

The source, pipeline definitions and deployment scripts are included. Shell, Python, Node.js, and Docker Compose configuration checks passed and are recorded in `evidence/local-validation.log`. Jenkins 2.580.2 started on loopback, but its built-in node stayed offline because the host had 488.60 MiB free, below Jenkins's 1 GiB threshold; no Jenkins build ran. AWS currently has zero EC2 instances in `ap-southeast-2`, and CloudShell reports account verification in progress. No public EC2 IP, remote build, GitHub webhook delivery, or live screenshot is claimed. The bootstrap does not create AWS resources.

The mentor's live deployment, process-manager runtime, webhook, and screenshot requirements still need an active EC2 host and a successful pipeline run. The corrected package is not evidence of a completed live deployment.

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

See [`deployment/README.md`](deployment/README.md) for EC2 setup and safe Jenkins/webhook access instructions.
