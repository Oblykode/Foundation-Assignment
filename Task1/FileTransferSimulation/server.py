#!/usr/bin/env python3
"""
Simple HTTP server that receives encrypted + Base64-encoded file data,
decodes and decrypts it, then reconstructs the original file.
"""

import base64
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

HOST = "127.0.0.1"
PORT = 8000
OUTPUT_DIR = "received_files"


SHARED_KEY = b"university-demo-key"


def xor_cipher(data, key):

    if not key:
        raise ValueError("Encryption key must not be empty")
    return bytes(byte ^ key[index % len(key)] for index, byte in enumerate(data))


class FileTransferHandler(BaseHTTPRequestHandler):


    def do_POST(self):
    
        if self.path != "/upload":
            self.send_error(404, "Endpoint not found. Use /upload")
            return

        print("\n[SERVER] Incoming HTTP POST request on /upload")

        content_length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_length)
        print(f"[SERVER] Received {content_length} bytes over HTTP")

        try:
            payload = json.loads(body.decode("utf-8"))
            filename = payload["filename"]
            encoded_data = payload["data"]

            print("[SERVER] Starting Base64 decoding process...")
            encrypted_bytes = base64.b64decode(encoded_data.encode("utf-8"))
            print(f"[SERVER] Base64 decoding complete ({len(encrypted_bytes)} bytes)")

            print("[SERVER] Starting decryption process (XOR)...")
            original_bytes = xor_cipher(encrypted_bytes, SHARED_KEY)
            print(f"[SERVER] Decryption complete ({len(original_bytes)} bytes)")

            os.makedirs(OUTPUT_DIR, exist_ok=True)
            output_path = os.path.join(OUTPUT_DIR, filename)

            with open(output_path, "wb") as file:
                file.write(original_bytes)

            print(f"[SERVER] File successfully reconstructed and saved: {output_path}")

            response = {
                "status": "success",
                "message": f"File '{filename}' received, decrypted, and reconstructed"
            }
            response_bytes = json.dumps(response).encode("utf-8")

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(response_bytes)))
            self.end_headers()
            self.wfile.write(response_bytes)

        except Exception as error:
            print(f"[SERVER] Error while processing upload: {error}")
            response = {"status": "error", "message": str(error)}
            response_bytes = json.dumps(response).encode("utf-8")

            self.send_response(400)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(response_bytes)))
            self.end_headers()
            self.wfile.write(response_bytes)

    def log_message(self, format, *args):
    
        return


def run_server():

    server = HTTPServer((HOST, PORT), FileTransferHandler)
    print(f"[SERVER] Listening on http://{HOST}:{PORT}")
    print("[SERVER] Waiting for client file upload...")
    server.serve_forever()


if __name__ == "__main__":
    run_server()
