---
title: "Your own certificate authority"
linkTitle: "Your own CA"
description: "Create a private certificate authority, issue a server certificate from it with the right Subject Alternative Names, serve HTTPS with it, and inspect the result with openssl s_client."
weight: 20
params:
  topic: tutorial
  area: "Security & access"
  time: "about 30 minutes"
  difficulty: "Intermediate"
tags: ["Security"]
---

{{< lab-meta >}}

## Goal

Create a private certificate authority, issue a server certificate from it with the right Subject Alternative Names, serve HTTPS with it, and inspect the result with `openssl s_client`.

## You'll need

- `openssl` (installed by default on most distros)
- `python3` for a tiny test server

## Setup

```bash
mkdir -p ~/ca-lab && cd ~/ca-lab
```

## Do it

### 1. Create the root CA

```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
  -keyout rootCA.key -out rootCA.crt \
  -subj "/CN=Thrown Home Lab Root CA"
```

`rootCA.key` is the crown jewel. Anyone with it can issue certificates that your machines trust.

### 2. Create the server key and a signing request

Describe the certificate in a config file. Browsers ignore the Common Name and only check `subjectAltName`, so list every name and IP address that clients use:

```bash
cat > csr.conf <<'EOF'
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext

[ dn ]
CN = lab.local

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = lab.local
DNS.2 = localhost
IP.1  = 127.0.0.1
EOF

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config csr.conf
```

### 3. Sign it with your CA

```bash
cat > cert.conf <<'EOF'
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
authorityKeyIdentifier = keyid,issuer
subjectAltName         = DNS:lab.local, DNS:localhost, IP:127.0.0.1
EOF

openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key \
  -CAcreateserial -out server.crt -days 90 -sha256 -extfile cert.conf
```

### 4. Inspect what you made

```bash
openssl x509 -in server.crt -noout -subject -issuer -dates -ext subjectAltName
openssl verify -CAfile rootCA.crt server.crt
```

### 5. Serve it and connect

Start a small HTTPS server in a second terminal:

```bash
cd ~/ca-lab
python3 - <<'EOF'
import http.server, ssl
srv = http.server.HTTPServer(("127.0.0.1", 8443), http.server.SimpleHTTPRequestHandler)
ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain("server.crt", "server.key")
srv.socket = ctx.wrap_socket(srv.socket, server_side=True)
print("Serving on https://localhost:8443")
srv.serve_forever()
EOF
```

Back in the first terminal:

```bash
curl -sI https://localhost:8443                         # fails: unknown CA
curl -sI --cacert rootCA.crt https://localhost:8443     # works
openssl s_client -connect localhost:8443 -servername localhost -CAfile rootCA.crt </dev/null | grep -E "subject=|issuer=|Verify return"
```

## What you should see

- Step 4: `server.crt: OK`, with the SAN list you defined.
- Step 5: the first `curl` fails with an error like `SSL certificate problem: unable to get local issuer certificate`. With `--cacert`, you get `HTTP/1.0 200 OK`. `s_client` ends with `Verify return code: 0 (ok)`.

{{< callout type="default" >}}
**Reading s_client output**

`openssl s_client -connect host:443 -servername host` is the go-to tool for TLS tickets. It shows the certificate chain the server actually sends, each certificate's subject and issuer, expiry dates, and the verification result. A missing intermediate certificate shows up here before it shows up anywhere else.
{{< /callout >}}

## Cleanup

Stop the server with **Ctrl+C**, then:

```bash
cd ~ && rm -rf ~/ca-lab
```

If you trusted the CA system-wide (see below), remove it too:

```bash
sudo rm /usr/local/share/ca-certificates/thrown-lab-root.crt
sudo update-ca-certificates --fresh
```

## Next steps

- Trust your CA system-wide on Ubuntu: copy `rootCA.crt` to `/usr/local/share/ca-certificates/thrown-lab-root.crt` and run `sudo update-ca-certificates`. Then `curl` works without `--cacert`.
- Request `https://127.0.0.2:8443` and get a name mismatch, because that IP isn't in the SANs.
- Put the certificate in front of Grafana or another homelab service.
