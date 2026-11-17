# Assignment 9 Jenkins CI/CD report

## Review feedback addressed

The first review requested visible Jenkinsfile definitions, process-manager configuration, live EC2 hosting, working webhooks and runtime evidence. Root-level `Jenkinsfile`, `Jenkinsfile.flask`, and `Jenkinsfile.express` now define the combined and per-app pipelines. `deployment/` contains the Ubuntu bootstrap, Flask systemd unit, Express PM2 ecosystem, PM2 boot unit, Nginx routes and restricted deployment helpers. `Jenkinsfile.local` provides an executable local pipeline for build, syntax validation and container deployment.

## Verification

Record the real Jenkins run output and local service health response under `evidence/` after execution. The AWS console currently reports zero EC2 instances in `ap-southeast-2`, and CloudShell is still blocked by account verification. There is therefore no active EC2 public URL, remote Jenkins controller, GitHub webhook delivery, or live AWS screenshot in this package. The local run validates Jenkins and the application deployment path but does not substitute for the reviewer's EC2 requirement.

## Resubmission

The updated ZIP must include this report and the root-level pipeline files. After an EC2 host and public Jenkins webhook route are available, capture the required deployment and webhook evidence before resubmitting if the mentor requires live proof.
