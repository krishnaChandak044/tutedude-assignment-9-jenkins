# Assignment 9 CI/CD Pipeline Report

## Objective

Deploy a Flask backend and an Express frontend to Amazon EC2, then automate validation and deployment with Jenkins and a GitHub push webhook. The deployment and both application pipelines are now live. This report distinguishes current runtime evidence from historical screenshots and unsuccessful initial attempts.

## Implementation

- `Jenkinsfile` defines the combined deployment pipeline; `Jenkinsfile.flask` and `Jenkinsfile.express` define independent application pipelines. Both live Jenkins jobs use their matching root-level files.
- The Flask API and Express frontend include health checks. Flask runs under Gunicorn and systemd on `127.0.0.1:5000`; PM2 Runtime manages Express under systemd on `127.0.0.1:3000`.
- Nginx serves the app on public port 80 and forwards `/github-webhook/` to Jenkins. Jenkins 2.580.2 listens only on `127.0.0.1:8080` and is accessed by SSH tunnel.
- The GitHub repository has an active push webhook. Real ping and push deliveries returned HTTP 200. Jenkins jobs `tutedude-flask` and `tutedude-express` are configured with GitHub push triggers; successful build logs are in `evidence/build-logs/`.
- EC2 runs Ubuntu 24.04 in `ap-southeast-2` (Sydney), instance type `t3.small`, 20 GiB gp3. SSH is restricted to an administrator IPv4 `/32`; application and webhook traffic use public HTTP on port 80.

## Verification

- Public application and backend API return HTTP 200; the live Flask health response is `Hello from the Flask backend on EC2.` The readiness endpoint returns `{"ready":true}`.
- Jenkins, Nginx, Flask systemd, and PM2 Runtime systemd services are active. App and Jenkins listeners are loopback-bound.
- Flask and Express pipeline console logs show successful real EC2 builds. The Express build log identifies its cause as a GitHub push. The GitHub delivery record confirms HTTP 200 from the configured endpoint.
- Initial builds failed due a root-owned Jenkins workspace, a Python 2-style executable reference (`python` instead of `python3`), an Express startup health-check race, and Jenkins restarts interrupting a run. Those initial failures are not presented as successful runs; subsequent successful logs are included separately.
- Static checks passed: shell syntax, Python compilation, Node syntax, and Docker Compose configuration. `Jenkinsfile.local` is provided but was not run.

See `evidence/ec2-live-validation.log`, `evidence/build-logs/`, and `evidence/github-webhook-deliveries.json` for direct output.

## Requirement status

| Requirement | Status and evidence |
| --- | --- |
| Jenkinsfiles and deployment helpers | Included at the repository root and in the package; the bootstrap installs the systemd units and restricted helpers. |
| Public EC2 deployment | Live at `http://13.211.139.18/`; the public page and backend health route were checked. The auto-assigned IPv4 can change after stop/start. |
| Process manager setup | Flask systemd and Express PM2 Runtime under systemd are active; app ports are not public. |
| Jenkins controller and pipelines | Jenkins 2.580.2 active on loopback; separate Flask and Express jobs completed successful builds. Console text is included. |
| GitHub webhook | Active push webhook; real push delivery returned HTTP 200 and triggered successful Express build #6. |
| Evidence screenshots | The app screenshot is a genuine capture from before the final backend message update; current response is in the live-check log. AWS-console, Jenkins UI, and GitHub UI screenshots could not be captured in the final browser pass, so none are claimed. |
| Historical AWS verification image | Included only as historical context. EC2 provisioning later succeeded. |

## Repositories

- Assignment: https://github.com/krishnaChandak044/tutedude-assignment-9-jenkins
- Flask source: https://github.com/krishnaChandak044/tutedude-flask-devops-app
- Express source: https://github.com/krishnaChandak044/tutedude-express-devops-app

The ZIP is `Jenkins_CICD_Krishna.zip` and contains one top-level folder named `Jenkins_CICD_Krishna/`.
