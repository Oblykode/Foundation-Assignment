#!/usr/bin/env python3
"""
Simple client that reads a file, encrypts it, Base64-encodes it,
and sends it to a server using HTTP POST.
"""

import base64
import json
import os
import urllib.request

SERVER_URL = "http://127.0.0.1:8000/upload"
INPUT_FILE = "sample_input.txt"


SHARED_KEY = b"university-demo-key"


def xor_cipher(data, key):

    if not key:
        raise ValueError("Encryption key must not be empty")
    return bytes(byte ^ key[index % len(key)] for index, byte in enumerate(data))


def send_file():
    
    if not os.path.exists(INPUT_FILE):
        print(f"[CLIENT] Error: '{INPUT_FILE}' was not found.")
        return

    print(f"[CLIENT] Reading file: {INPUT_FILE}")
    with open(INPUT_FILE, "rb") as file:
        file_bytes = file.read()
    print(f"[CLIENT] File read complete ({len(file_bytes)} bytes)")

    print("[CLIENT] Starting encryption process (XOR)...")
    encrypted_bytes = xor_cipher(file_bytes, SHARED_KEY)
    print(f"[CLIENT] Encryption complete ({len(encrypted_bytes)} bytes)")

    print("[CLIENT] Starting Base64 encoding process...")
    encoded_data = base64.b64encode(encrypted_bytes).decode("utf-8")
    print(f"[CLIENT] Encoding complete ({len(encoded_data)} Base64 characters)")

    payload = {
        "filename": INPUT_FILE,
        "data": encoded_data,
        "algorithm": "xor+base64"
    }
    json_payload = json.dumps(payload).encode("utf-8")

    request = urllib.request.Request(
        SERVER_URL,
        data=json_payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    print(f"[CLIENT] Sending HTTP POST request to {SERVER_URL}")
    try:
        with urllib.request.urlopen(request) as response:
            response_body = response.read().decode("utf-8")
            print("[CLIENT] HTTP transmission successful")
            print(f"[CLIENT] Server response: {response_body}")
    except Exception as error:
        print(f"[CLIENT] HTTP transmission failed: {error}")


if __name__ == "__main__":
    send_file()
