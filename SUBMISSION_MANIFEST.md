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
- `architecture-deployed.svg` — verified EC2 topology, webhook route, private Jenkins controller, and deployment path.
- `evidence/local-validation.log` and `evidence/jenkins-controller.log` — older local checks and local controller status.
- `evidence/ec2-live-validation.log` — fresh EC2 checks for public app HTTP 200, Flask readiness and final health response, active services, and listener bindings.
- `evidence/ec2-app-live.png` — genuine Chrome capture of the public app before the final backend response text update; use the log for the current API response.
- `evidence/build-logs/` — successful Flask and Express Jenkins console logs. Express build #6 was push-triggered by GitHub; both live pipelines are separately configured.
- `evidence/github-webhook-deliveries.json` — real push and ping delivery records with HTTP response codes.
- `evidence/README.md` — clarifies which evidence is current and which historical context/screenshots are unavailable.
- `evidence/aws-verification-blocker.png` — genuine historical evidence of the earlier CloudShell verification message; EC2 launch later succeeded.

Live deployment and both Jenkins pipelines are verified. GitHub push delivery returned HTTP 200 and triggered a successful Express build. The package does not include AWS-console, Jenkins UI, or GitHub UI screenshots; see `evidence/README.md` for the evidence limitations and current logs.
