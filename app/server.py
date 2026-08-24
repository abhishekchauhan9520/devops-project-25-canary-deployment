#!/usr/bin/env python3
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

VERSION = os.getenv('APP_VERSION', 'v1')
PORT = int(os.getenv('PORT', '8080'))

class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body):
        payload = body.encode()
        self.send_response(code)
        self.send_header('Content-Type', 'text/plain; charset=utf-8')
        self.send_header('Content-Length', str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

    def do_GET(self):
        if self.path == '/healthz':
            self._send(200, 'ok')
        elif self.path == '/':
            self._send(200, f'canary-demo {VERSION}\n')
        else:
            self._send(404, 'not found\n')

    def log_message(self, fmt, *args):
        print(f'{self.address_string()} - {fmt % args}')

if __name__ == '__main__':
    HTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
