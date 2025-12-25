import os
from flask import Flask, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION","dev")

REQUESTS = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["endpoint"]
)

@app.route("/")
def hello():
    REQUESTS.labels(endpoint="/").inc()
    return "Hello world! Don't sleep! Time to work!"

@app.route("/version")
def hello():
    REQUESTS.labels(endpoint="/").inc()
    return f"version {APP_VERSION}"

@app.route("/health")
def health():
    return "OK", 200

@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9000)

