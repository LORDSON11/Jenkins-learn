from http.server import BaseHTTPRequestHandler, HTTPServer

class HelloHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"App Deployed Successfully via Jenkins Pipeline!")

if __name__ == '__main__':
    server = HTTPServer(('', 80), HelloHandler)
    print("Starting server...")
    server.serve_forever()
