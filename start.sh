#!/bin/bash

# Ensure a password is set
if [ -z "$ROOT_PASSWORD" ]; then
  echo "WARNING: ROOT_PASSWORD not set. Generating a random one..."
  ROOT_PASSWORD=$(openssl rand -base64 12)
  echo "Generated Password: $ROOT_PASSWORD"
fi

# Set the password for root
echo "root:$ROOT_PASSWORD" | chpasswd

# Start SSH
echo "✅ ClaudeBox Environment Ready."
echo "🔌 Connect via: ssh root@<proxy-domain> -p <port>"
echo "🔑 Password: (The value of ROOT_PASSWORD)"

/usr/sbin/sshd -D
