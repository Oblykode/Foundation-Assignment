# File Transfer Simulation (Encryption + Base64 + HTTP)

This project is a beginner-friendly simulation of secure-style data exchange in computer networking.  
The client reads a file, encrypts it with a simple XOR key, Base64-encodes it, and sends it to the server using HTTP POST.  
The server receives the encoded payload, decodes Base64, decrypts the data, and reconstructs the original file.

## Project Files
- `client.py`: Reads file -> encrypts -> Base64 encodes -> sends HTTP POST.
- `server.py`: Receives HTTP POST -> Base64 decodes -> decrypts -> saves reconstructed file.
- `sample_input.txt`: Sample source file to transfer.
- `received_files/sample_input.txt`: Reconstructed output file after transfer.

## Requirements
- Python 3.x

## How To Run
1. Open terminal 1 in the project directory and start the server:
   ```bash
   python server.py
   ```
2. Open terminal 2 in the same directory and run the client:
   ```bash
   python client.py
   ```
3. Verify reconstructed file:
   - `received_files/sample_input.txt`

## Expected Console Logs
- File read on client
- Encryption process on client (XOR demo)
- Base64 encoding on client
- HTTP transmission client -> server
- Base64 decoding on server
- Decryption process on server
- File successfully reconstructed

## Data Flow Diagram
```text
[File]
   |
   v
[XOR Encryption]
   |
   v
[Base64 Encoding]
   |
   v
[HTTP POST Transmission]
   |
   v
[Base64 Decoding]
   |
   v
[XOR Decryption]
   |
   v
[Reconstructed File]
```

## Short Explanation 
This simulation demonstrates how application-layer data preparation supports reliable communication over web protocols.  
In the client-server model, a file is first read as raw bytes by the client. To represent a confidentiality step, the bytes are transformed using a simple XOR-based encryption routine with a shared key. Although XOR here is intentionally basic for learning, it models the concept that data can be protected before transmission.

After encryption, the client converts the binary output into Base64 text. This step is important because HTTP APIs frequently exchange text-based formats such as JSON, where raw binary may not be transported cleanly. Base64 makes the encrypted bytes safe to embed in JSON without changing their underlying information content. The client then sends the payload to the server through an HTTP POST request.

On the server side, the reverse operations are performed in sequence. The server receives the JSON payload, extracts the Base64 string, decodes it back into encrypted bytes, and then decrypts those bytes with the same shared XOR key. The recovered plaintext bytes are written to disk, reconstructing the original file content. Successful reconstruction confirms that the data path preserved integrity through encoding and HTTP transport.

From a cybersecurity perspective, this exercise separates encoding from encryption. Base64 is not security; it is a data representation method. Encryption provides confidentiality, while HTTP provides transport. In real-world deployments, stronger cryptography and HTTPS/TLS would be required for robust security.

## Important Note
The XOR cipher is for educational demonstration only.  
For real secure systems, use HTTPS/TLS and modern cryptographic libraries.

## Troubleshooting
- If server says port 8000 is already in use, stop old Python server processes and restart `server.py`.
- If client cannot connect, confirm server is running first.
