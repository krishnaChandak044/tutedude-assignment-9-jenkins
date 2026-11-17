# Assignment 9 — Jenkins CI/CD report

Two Jenkinsfiles are supplied for Flask and Express. Each checks out its standalone source repo, installs dependencies, validates syntax and deploys/restarts using systemd or PM2. The separate source repos are published at https://github.com/krishnaChandak044/tutedude-flask-devops-app and https://github.com/krishnaChandak044/tutedude-express-devops-app. Configure required Jenkins GitHub/Pipeline/Python/NodeJS plugins, credentials, secured deploy host and GitHub webhooks.

Jenkins and an EC2 deploy host are not configured here. No pipeline executions, webhook events, server runtime or screenshots exist. The Jenkinsfiles are prepared for setup but are not proof of a functioning live CI/CD system.
