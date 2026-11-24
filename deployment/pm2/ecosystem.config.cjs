module.exports = {
  apps: [{
    name: 'tutedude-express',
    script: '/opt/tutedude/express/server.js',
    cwd: '/opt/tutedude/express',
    instances: 1,
    exec_mode: 'fork',
    autorestart: true,
    max_restarts: 10,
    env: {
      NODE_ENV: 'production',
      HOST: '127.0.0.1',
      PORT: '3000',
      API_URL: 'http://127.0.0.1:5000'
    }
  }]
};
