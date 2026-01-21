# ClaudeBox on Railway

This repository contains the template for deploying "ClaudeBox" on Railway. It provides a full Ubuntu-based development environment with Claude Code, Python (uv), Node.js, and Zsh.

## Deployment Steps

1.  **Push to GitHub**: Push this repository to your GitHub account.
2.  **Deploy on Railway**: Connect the repository to a new project on Railway.
3.  **Configure Environment Variables**:
    *   `ROOT_PASSWORD`: Set a secure password (e.g., `YourSecurePassword123`).
4.  **Add Volume**:
    *   Go to Settings > Volumes.
    *   Add a new volume mounted at `/root`.
5.  **Enable TCP Proxy**:
    *   Go to Settings > Networking > TCP Proxy.
    *   Note the domain and port (e.g., `proxy.railway.app:12345`).

## Usage

Connect via SSH:

```bash
ssh root@<proxy-domain> -p <port>
```

Enter your `ROOT_PASSWORD` when prompted.

### First Time Setup
Once logged in, authenticate Claude Code:

```bash
claude login
```

### Included Tools
*   **Claude Code**: `claude`
*   **Python**: `uv`
*   **Node.js**: `node`, `npm`
*   **GitHub CLI**: `gh`
*   **Shell**: Zsh with Oh My Zsh & Powerline
*   **Utilities**: `fzf`, `rg`, `bat`, `tmux`
