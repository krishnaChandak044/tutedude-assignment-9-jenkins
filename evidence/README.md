# Assignment 9 evidence

Add dated, unedited screenshots and logs here after the corresponding step actually runs:

- `jenkins-controller.png`: Jenkins dashboard and installed plugins.
- `pipeline-flask.png` and `pipeline-express.png`: successful console/build pages.
- `ec2-services.png`: `systemctl status` and `pm2 status` from the deployed host.
- `application-home.png` and `application-health.png`: browser checks against the EC2 public IP.
- `github-webhook.png`: GitHub webhook delivery with a successful response.
- `build-logs/`: corresponding console text logs with secrets redacted.

`ec2-live-validation.log` records genuine checks against EC2: public HTTP status, Flask readiness, health through Nginx and Express, active systemd services, and listener bindings. `local-validation.log` and `jenkins-controller.log` are older local checks, not proof of a successful EC2 Jenkins build.

`aws-verification-blocker.png` is a genuine screenshot of the AWS console reporting that account verification was in progress and preventing CloudShell creation. EC2 launch later succeeded, so this is historical context only. Jenkins setup, successful pipeline runs, webhook deliveries, and their screenshots are still pending. Follow the checklist in `../deployment/README.md`.
