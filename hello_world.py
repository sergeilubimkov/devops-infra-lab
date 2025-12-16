from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
           self.send_response(200)
           self.end_headers()
           self.wfile.write(b"OK")
        else:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Hello world! Don't  sleep! Time to work!")

server = HTTPServer(("0.0.0.0", 9000), SimpleHandler)
server.serve_forever()
