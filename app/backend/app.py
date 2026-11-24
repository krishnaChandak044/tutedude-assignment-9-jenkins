from flask import Flask, jsonify
app=Flask(__name__)
@app.get("/api/health")
def health(): return jsonify({"status":"ok","service":"flask-backend","message":"Hello from the Flask backend on EC2."})
@app.get("/api/ready")
def ready(): return jsonify({"ready":True})
