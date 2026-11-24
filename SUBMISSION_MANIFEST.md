# Submission file manifest

The ZIP contains one top-level folder, `Jenkins_CICD_Krishna/`. The paths below are relative to that folder.

## Jenkins pipeline files

- `Jenkinsfile` — combined Flask and Express EC2 deployment pipeline.
- `Jenkinsfile.flask` — Flask pipeline.
- `Jenkinsfile.express` — Express pipeline.
- `Jenkinsfile.local` — local Compose pipeline definition; it has not been run.

## Deployment helpers and service units

| File included in ZIP | Installed by the bootstrap as |
| --- | --- |
| `deployment/scripts/tutedude-deploy-flask` | `/usr/local/sbin/tutedude-deploy-flask` |
| `deployment/scripts/tutedude-deploy-express` | `/usr/local/sbin/tutedude-deploy-express` |
| `deployment/systemd/tutedude-flask.service` | `/etc/systemd/system/tutedude-flask.service` |
| `deployment/systemd/tutedude-pm2.service` | `/etc/systemd/system/tutedude-pm2.service` |

The install mappings are implemented in `deployment/bootstrap-ubuntu.sh`. The helpers and service units have been installed on EC2 instance `i-02064e2837ce19769` in `ap-southeast-2`.

## Other related files

- `deployment/pm2/ecosystem.config.cjs` — PM2 application configuration.
- `deployment/nginx/tutedude.conf` — application and webhook proxy routes.
- `deployment/bootstrap-ubuntu.sh` — Ubuntu install and service wiring, including explicit Jenkins loopback binding.
- `deployment/README.md` — detailed ordered deployment, security, Jenkins, webhook, verification, troubleshooting, evidence, and teardown runbook.
- `jenkins/plugins.txt` — Jenkins plugin names.
- `Assignment_Report.docx` and `docs/Assignment_Report.md` — implementation, validation, and outstanding requirements.
- `architecture-target.png` — original target diagram.
- `architecture-deployed.svg` — current EC2 topology; dashed arrows label the Jenkins/webhook flow that still needs live verification.
- `evidence/local-validation.log` and `evidence/jenkins-controller.log` — older local checks and local controller status.
- `evidence/ec2-live-validation.log` — actual EC2 checks for public app HTTP 200, Flask readiness, health through Nginx/Express, active services, and listener bindings.
- `evidence/aws-verification-blocker.png` — genuine historical evidence of the earlier CloudShell verification message; EC2 launch later succeeded.

Jenkins first-run setup, pipeline execution, webhook delivery, and the corresponding screenshots are still outstanding. The runbook lists the remaining evidence.
