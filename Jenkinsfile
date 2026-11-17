pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  triggers { githubPush() }
  environment {
    DEPLOY_BASE = '/opt/tutedude'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Install Flask dependencies') {
      steps { sh 'python3 -m venv .venv && . .venv/bin/activate && pip install --disable-pip-version-check -r app/backend/requirements.txt' }
    }
    stage('Install Express dependencies') {
      steps { dir('app/frontend') { sh 'npm ci' } }
    }
    stage('Validate') {
      steps {
        sh 'python -m compileall -q app/backend'
        dir('app/frontend') { sh 'node --check server.js' }
      }
    }
    stage('Deploy Flask and Express') {
      steps {
        sh 'sudo /usr/local/sbin/tutedude-deploy-flask "$WORKSPACE"'
        sh 'sudo /usr/local/sbin/tutedude-deploy-express "$WORKSPACE"'
        sh 'curl --fail --silent --show-error http://127.0.0.1/api/health'
      }
    }
  }
  post { always { cleanWs() } }
}
