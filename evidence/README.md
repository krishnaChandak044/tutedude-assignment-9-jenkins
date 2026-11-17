# Assignment 9 evidence

Add dated, unedited screenshots and logs here after the corresponding step actually runs:

- `jenkins-controller.png`: Jenkins dashboard and installed plugins.
- `pipeline-flask.png` and `pipeline-express.png`: successful console/build pages.
- `ec2-services.png`: `systemctl status` and `pm2 status` from the deployed host.
- `application-home.png` and `application-health.png`: browser checks against the EC2 public IP.
- `github-webhook.png`: GitHub webhook delivery with a successful response.
- `build-logs/`: corresponding console text logs with secrets redacted.

`local-validation.log` records the checks that passed and explains why a Jenkins build could not run on this host. No live EC2/Jenkins/webhook screenshots are included because those services have not been deployed and verified.
