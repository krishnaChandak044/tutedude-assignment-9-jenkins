# Assignment 9 — Jenkins CI/CD (Krishna)

**Repository:** https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins

`app/` includes Flask/Express code and Docker Compose. `jenkins/Jenkinsfile.flask` and `jenkins/Jenkinsfile.express` define separate checkout, dependency install, validation, deployment/restart, and webhook-triggered pipelines. Configure Jenkins Git, Pipeline, GitHub, NodeJS and Python tools; create two pipeline jobs pointing to the respective Jenkinsfiles. Configure GitHub webhook to `https://<jenkins-host>/github-webhook/`. Set deployment directories/systemd/PM2 permissions on a secured host. Never place secrets in Jenkinsfile; use credentials binding. Jenkins and EC2 are not installed/provisioned here, so no live build log, webhook event, or public app URL is claimed.
