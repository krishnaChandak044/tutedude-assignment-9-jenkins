# Assignment 9 — Jenkins CI/CD (Krishna)

**Repository:** https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins

## Included

`app/` contains Flask and Express source. Separate declarative pipeline files are in `jenkins/Jenkinsfile.flask` and `jenkins/Jenkinsfile.express`, and duplicated in each app source repository. Standalone source repositories are included under `source_repos/` and published at https://github.com/krishnaChandak044/tutedude-flask-devops-app and https://github.com/krishnaChandak044/tutedude-express-devops-app. The pipelines check out, install dependencies, validate syntax and deploy/restart using systemd or PM2. `githubPush()` enables Jenkins GitHub push trigger integration when configured.

## Jenkins setup

Install Jenkins LTS on the same EC2 instance or a separate host. Install Git, Pipeline, GitHub, NodeJS, Python and Workspace Cleanup plugins. Create two Pipeline jobs that point to the Flask and Express repositories and their root `Jenkinsfile`. Configure the deployment host with `/opt/tutedude/flask` and `/opt/tutedude/express`, a Flask systemd service and PM2 for Express. Grant the Jenkins service account only required deploy/restart commands; never put credentials in the repository.

Configure GitHub webhook for each repository to `https://YOUR_JENKINS_HOST/github-webhook/` (push events). Public access to Jenkins should use TLS and authentication; do not expose an unsecured controller. See `docs/Assignment_Report.md` for what was actually executed.

## Current execution status
Jenkins and a reachable EC2 host are not available: AWS CloudShell is blocked during account verification, and this environment has no Jenkins controller. Therefore no pipeline build, webhook event, live EC2 URL or Jenkins console screenshot is claimed. Pipeline scripts are included but require setup and a successful run before the live-deployment portion can be marked complete.
