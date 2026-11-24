# Assignment 9 CI/CD Pipeline Report

## Objective

Deploy a Flask backend and an Express frontend to Amazon EC2, then automate validation and deployment with Jenkins. This report summarizes the implementation and the live EC2 deployment, and marks the Jenkins build and webhook steps that remain.

## Implementation included

- `Jenkinsfile` defines the combined EC2 deployment pipeline. `Jenkinsfile.flask` and `Jenkinsfile.express` define app-specific pipelines. `Jenkinsfile.local` defines local Docker Compose build and health-check stages; it was not run.
- The project contains Flask backend and Express frontend source, health and readiness endpoints, Dockerfiles, Compose configuration, and an Express package lock.
- `deployment/bootstrap-ubuntu.sh` installs Jenkins, Java 21, Python, Node.js, PM2, and Nginx on Ubuntu. It uses the Jenkins 2026 repository signing key. Deployment helpers copy application code and restart services.
- The Flask systemd unit runs Gunicorn on `127.0.0.1:5000`. PM2 Runtime manages Express under systemd on `127.0.0.1:3000`. Nginx serves the app on public port 80 and forwards only `/github-webhook/` to Jenkins; Jenkins is bound to `127.0.0.1:8080` and administrators use an SSH tunnel.
- `jenkins/plugins.txt` lists the Jenkins plugins. `deployment/README.md` is the ordered runbook for provisioning, bootstrap, private Jenkins access, webhook configuration, verification, troubleshooting, evidence, and teardown.

`SUBMISSION_MANIFEST.md` lists the exact paths of the files in the ZIP and maps the deployment helper and systemd source files to their installation destinations.

`architecture-target.png` is the original target design. `architecture-deployed.svg` diagrams the verified EC2 services and marks the Jenkins job and webhook path as pending until they are exercised; neither diagram is execution evidence.

## Checks performed

- `bash -n` on the bootstrap and both deployment helpers: passed.
- `python3 -m compileall -q app/backend`: passed.
- `node --check` on the Express server and PM2 ecosystem file: passed.
- `docker compose -f app/docker-compose.yml config --quiet`: passed.
- Jenkins 2.580.2 is active on EC2 and bound to loopback. Jenkins initial setup is waiting for the account owner to unlock the wizard and create an administrator.
- EC2 instance `i-02064e2837ce19769` is running Ubuntu 24.04 in `ap-southeast-2` as `t3.small`, with a 20 GiB gp3 volume and public IPv4 `13.211.139.18`.
- Live checks returned HTTP 200 for the public app, `{"ready":true}` from Flask readiness, and the Flask health JSON through Express/Nginx. systemd reports Jenkins, Nginx, Flask, and PM2 Runtime active. See `evidence/ec2-live-validation.log`.
- The local Jenkins controller log records an earlier offline-node condition; it is historical context, not evidence of this EC2 deployment.

See `evidence/local-validation.log` and `evidence/jenkins-controller.log` for the corresponding output.

## Requirement status

| Requirement | Current status |
| --- | --- |
| Jenkinsfiles and deployment configuration | Included in the repository and ZIP. The root combined pipeline is ready; a live Jenkins build has not run yet. |
| Public EC2 deployment | Live at `http://13.211.139.18/`; HTTP 200 verified. The auto-assigned IP may change if the instance is stopped and started. |
| systemd and PM2 on a live host | Verified active: Flask systemd service and PM2 Runtime systemd service. Express, Flask, and Jenkins listen on loopback ports. |
| Jenkins controller and successful build | Jenkins 2.580.2 is installed and active on loopback. The owner must finish the first-run wizard and create their admin account; no pipeline build has run yet. |
| GitHub webhook | Nginx route and `githubPush()` trigger are configured in source. Live webhook registration and delivery remain outstanding. |
| AWS blocker screenshot | Included as historical context for the earlier CloudShell verification message; EC2 later allowed an instance launch. It is not deployment evidence. |
| Live EC2 checks | Actual output is included in `evidence/ec2-live-validation.log`; browser/terminal screenshots, webhook delivery, and successful Jenkins build evidence remain outstanding. |
| Architecture diagram | `architecture-deployed.svg` depicts the actual EC2 topology and marks unverified automation paths as pending. |

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

## Next deployment steps

Complete the Jenkins first-run wizard, create the Pipeline job using the root `Jenkinsfile`, configure the GitHub push webhook, and run the pipeline. Then verify the public app health endpoint, systemd and PM2 Runtime status, webhook delivery, and Jenkins console output. Capture genuine screenshots and add them with logs before treating the assignment as complete.

## Submission package

The ZIP is named `Jenkins_CICD_Krishna.zip` and contains one top-level folder named `Jenkins_CICD_Krishna/`, following the assignment's packaging directions.
