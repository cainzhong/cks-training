#!/bin/bash
echo "CA根证书的生成步骤"
# Generate CA private key 
openssl genrsa -out ca.key 2048
# Generate CSR 
openssl req -new -key ca.key -out ca.csr -subj "/C=CN/ST=Shanghai/L=Shanghai/O=Micro Focus/CN=tzhong.com/emailAddress=tzhong@tzhong.com"
# Generate Self Signed certificate（CA 根证书）
openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt

echo "用户证书的生成步骤"
echo "Server Certificates..."
# private key
openssl genrsa -out server.key 1024
# generate csr
openssl req -new -key server.key -out server.csr -config req.cnf
# generate certificate
openssl x509 -req -days 365 -in server.csr -out server.crt -CA ca.crt -CAkey ca.key -CAcreateserial -extfile req.cnf -extensions v3_req