# Assignment 9 CI/CD Pipeline Report

## Objective

Deploy a Flask backend and an Express frontend to Amazon EC2, then automate validation and deployment with Jenkins. This report describes the delivered source and configuration and separates completed local checks from live deployment evidence that has not been produced.

## Implementation included

- `Jenkinsfile` defines the combined EC2 deployment pipeline. `Jenkinsfile.flask` and `Jenkinsfile.express` define app-specific pipelines. `Jenkinsfile.local` defines local Docker Compose build and health-check stages; it was not run.
- The project contains Flask backend and Express frontend source, health and readiness endpoints, Dockerfiles, Compose configuration, and an Express package lock.
- `deployment/bootstrap-ubuntu.sh` installs Jenkins, Java 21, Python, Node.js, PM2, and Nginx on Ubuntu. Deployment helpers copy application code and restart services.
- The Flask systemd unit runs Gunicorn on localhost port 5000. PM2 manages Express on localhost port 3000. Nginx serves the app on port 80 and forwards only `/github-webhook/` to Jenkins; the instructions keep Jenkins administration private.
- `jenkins/plugins.txt` lists the Jenkins plugins. `deployment/README.md` describes the host setup, pipeline job paths, webhook configuration, and verification commands.

`SUBMISSION_MANIFEST.md` lists the exact paths of the files in the ZIP and maps the deployment helper and systemd source files to their installation destinations.

`architecture-target.png` diagrams the intended EC2, Nginx, application, Jenkins, and webhook design. It is labeled as a target architecture; it does not represent a verified live deployment.

## Checks performed

- `bash -n` on the bootstrap and both deployment helpers: passed.
- `python3 -m compileall -q app/backend`: passed.
- `node --check` on the Express server and PM2 ecosystem file: passed.
- `docker compose -f app/docker-compose.yml config --quiet`: passed.
- Jenkins 2.580.2 started locally on `127.0.0.1:8180`. Its built-in node stayed offline because only 488.60 MiB was free, below Jenkins's 1.00 GiB threshold. No Jenkins pipeline build ran.

See `evidence/local-validation.log` and `evidence/jenkins-controller.log` for the corresponding output.

## Requirement status

| Requirement | Current status |
| --- | --- |
| Jenkinsfiles and deployment configuration | Included in this repository and ZIP. Remote pipelines have not been run. |
| Public EC2 deployment | Not completed. The AWS console showed zero EC2 instances in `ap-southeast-2`; CloudShell reported account verification in progress. |
| systemd and PM2 on a live host | Unit and ecosystem files are included; neither service has been verified on EC2. |
| Jenkins controller and successful build | Plugin list and bootstrap are included. The local controller started, but no build ran because its built-in node was offline. |
| GitHub webhook | Nginx routing and pipeline trigger configuration are included. No live webhook registration or delivery is claimed. |
| Required screenshots | Not included. Genuine EC2, running application, terminal, and successful Jenkins build screenshots must be captured after deployment. |
| Architecture diagram | Included as `architecture-target.png`; it depicts the intended design and is not deployment evidence. |

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

## Next deployment steps

After AWS account verification is complete, provision an Ubuntu EC2 host and run `deployment/bootstrap-ubuntu.sh`. Create a Jenkins Pipeline job using `Jenkinsfile`, configure the GitHub webhook secret in Jenkins, and push a commit to trigger the pipeline. Verify the public app health endpoint, `systemctl status`, `pm2 status`, and Jenkins console output. Capture genuine screenshots and add them with the logs before treating the assignment as complete.

## Submission package

The ZIP is named `Jenkins_CICD_Krishna.zip` and contains one top-level folder named `Jenkins_CICD_Krishna/`, following the assignment's packaging directions.
