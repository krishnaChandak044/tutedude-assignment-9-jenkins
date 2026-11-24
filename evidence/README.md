# Assignment 9 evidence

This folder contains genuine runtime evidence. Text logs are direct output from the EC2 host, Jenkins console files, and GitHub API; they do not claim to be screenshots.

- `ec2-app-live.png`: Chrome screenshot of the public EC2 app with the Flask health response.
- `jenkins-controller.png`: Jenkins dashboard and installed plugins.
- `pipeline-flask.png` and `pipeline-express.png`: successful console/build pages.
- `ec2-services.png`: `systemctl status` and `pm2 status` from the deployed host.
- `application-home.png` and `application-health.png`: browser checks against the EC2 public IP.
- `github-webhook.png`: GitHub webhook delivery with a successful response.
- `build-logs/`: corresponding console text logs with secrets redacted.

`ec2-live-validation.log` records fresh checks against EC2: public HTTP status, Flask readiness, the final backend health response, active systemd services, and listener bindings. `build-logs/` contains successful console output from real EC2 Jenkins builds, including a GitHub push-triggered Express build. `github-webhook-deliveries.json` records real GitHub push delivery statuses and endpoint responses. `local-validation.log` and `jenkins-controller.log` are older local checks, not proof of the EC2 Jenkins builds.

`ec2-app-live.png` is a genuine browser capture made before the final backend response text was deployed; the current response is in `ec2-live-validation.log`. `aws-verification-blocker.png` is a genuine screenshot of an earlier AWS console verification delay; EC2 launch later succeeded, so that image is historical context only. No AWS-console, Jenkins UI, or GitHub UI screenshots are included because the desktop browser capture bridge timed out during final evidence collection. The runbook remains in `../deployment/README.md`.
