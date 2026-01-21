# ClaudeBox on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/dgavriloff/claudebox-railway)

This repository contains the template for deploying "ClaudeBox" on Railway. It provides a full Ubuntu-based development environment with Claude Code, Python (uv), Node.js, and Zsh.

## Features
- **User**: Runs as non-root user `box` (with `sudo` access).
- **Tools**: Claude Code, `uv`, `gh`, `fzf`, `rg`, `bat`, `tmux`.
- **Persistent**: Volume-ready for `/home/box`.

## Deployment Steps

1.  **Click the "Deploy on Railway" button** above.
2.  **Configure Environment Variables**:
    *   `ROOT_PASSWORD`: Set a secure password for the `box` user.
3.  **Add Volume (Critical)**:
    *   After deployment, go to **Settings > Volumes**.
    *   Add a new volume mounted at `/home/box`.
4.  **Enable TCP Proxy**:
    *   Go to **Settings > Networking > TCP Proxy**.
    *   Ensure it proxies to port `22`.
    *   Note the domain and port (e.g., `proxy.railway.app:12345`).

## Usage

Connect via SSH:

```bash
ssh box@<proxy-domain> -p <port>
```

Enter your `ROOT_PASSWORD` when prompted.

### Port Forwarding (Recommended)
To access web apps running on port 3000 inside the box:

```bash
ssh -L 3000:localhost:3000 box@<proxy-domain> -p <port>
```

### First Time Setup
Once logged in, authenticate Claude Code:

```bash
claude login
```
