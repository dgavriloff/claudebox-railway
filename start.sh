#!/bin/bash

# Ensure a password is set
if [ -z "$ROOT_PASSWORD" ]; then
  echo "WARNING: ROOT_PASSWORD not set. Generating a random one..."
  ROOT_PASSWORD=$(openssl rand -base64 12)
  echo "Generated Password: $ROOT_PASSWORD"
fi

# Set the password for 'box' user (sudo access)
echo "box:$ROOT_PASSWORD" | chpasswd
# Also set root password just in case, though we primarily use box
echo "root:$ROOT_PASSWORD" | chpasswd

# Ensure /var/run/sshd exists
mkdir -p /var/run/sshd

# Permit SSH configuration
# We need to ensure we can login as box
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Ensure permissions on /home/box are correct (important for volume mounts)
# We responsibly fix ownership only if it's WRONG to avoid slow startup on huge volumes
if [ "$(stat -c '%U' /home/box)" != "box" ]; then
    chown -R box:box /home/box
fi

# Start SSH
echo "✅ ClaudeBox Environment Ready."
echo "🔌 Connect via: ssh box@<proxy-domain> -p <port>"
echo "🔑 Password: (The value of ROOT_PASSWORD)"
echo "ℹ️  Note: You have sudo access. Use 'sudo <command>' if needed."

/usr/sbin/sshd -D
