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

The install mappings are implemented in `deployment/bootstrap-ubuntu.sh`. The helpers and service units are present in this archive; their inclusion does not mean they have been installed or run on a live EC2 instance.

## Other related files

- `deployment/pm2/ecosystem.config.cjs` — PM2 application configuration.
- `deployment/nginx/tutedude.conf` — application and webhook proxy routes.
- `jenkins/plugins.txt` — Jenkins plugin names.
- `Assignment_Report.docx` and `docs/Assignment_Report.md` — implementation, validation, and outstanding requirements.
- `architecture-target.png` — target system diagram, clearly labeled as not yet deployed.
- `evidence/local-validation.log` and `evidence/jenkins-controller.log` — actual local checks and controller status. No live EC2, webhook, or successful build screenshots are included.
