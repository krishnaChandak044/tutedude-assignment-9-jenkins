# Assignment 9 Jenkins CI/CD report

## Review feedback addressed

The first review requested visible Jenkinsfile definitions, process-manager configuration, live EC2 hosting, working webhooks and runtime evidence. Root-level `Jenkinsfile`, `Jenkinsfile.flask`, and `Jenkinsfile.express` now define the combined and per-app pipelines. `deployment/` contains the Ubuntu bootstrap, Flask systemd unit, Express PM2 ecosystem, PM2 boot unit, Nginx routes and restricted deployment helpers. `Jenkinsfile.local` provides an executable local pipeline for build, syntax validation and container deployment.

## Verification

Shell syntax, Python compilation, Node.js syntax, and Docker Compose configuration checks passed; see `evidence/local-validation.log`. Jenkins 2.580.2 started on loopback, but Jenkins marked its built-in node offline because only 488.60 MiB remained, below its 1 GiB threshold. No Jenkins pipeline build ran. The AWS console showed zero EC2 instances in `ap-southeast-2`, and CloudShell remained in account verification. There is no active EC2 public URL, remote Jenkins build, GitHub webhook delivery, or live deployment screenshot in this package.

## Resubmission

The updated ZIP includes this report and the root-level pipeline files. The live EC2 deployment, systemd and PM2 runtime, webhook delivery, and screenshots remain to be completed before the mentor's full requirements are met.
