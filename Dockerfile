# We use Ubuntu to match the Debian-based nature of ClaudeBox
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# 1. Install Core Dependencies & Tools (Matching ClaudeBox "Core" Profile)
RUN apt-get update && apt-get install -y \
    curl wget git sudo \
    build-essential \
    vim nano \
    openssh-server \
    zsh \
    # "build-tools" profile equivalents
    cmake autoconf automake \
    # Utilities mentioned in ClaudeBox
    fzf ripgrep bat tmux \
    && rm -rf /var/lib/apt/lists/*

# 2. Install GitHub CLI (gh)
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh

# 3. Install Node.js 20 & Claude Code
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @anthropic-ai/claude-code

# 4. Install 'uv' (The Python manager mentioned in ClaudeBox)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# 9. Create non-root user 'box'
# We set a fixed UID/GID for consistency
RUN groupadd -g 1000 box && \
    useradd -m -u 1000 -g box -s /bin/zsh box && \
    usermod -aG sudo box

# 10. Install 'uv' for the 'box' user
USER box
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/box/.cargo/bin:/home/box/.local/bin:$PATH"

# 11. Install Oh My Zsh for 'box'
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 12. Startup Script
USER root
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 13. Workspace Setup
WORKDIR /home/box/project
# Set ownership of workspace to box
RUN chown -R box:box /home/box/project

# 14. Add persistent history for box
RUN echo 'export HISTFILE=/home/box/project/.zsh_history' >> /home/box/.zshrc && \
    echo 'export HISTSIZE=10000' >> /home/box/.zshrc && \
    echo 'export SAVEHIST=10000' >> /home/box/.zshrc

EXPOSE 22

CMD ["/start.sh"]
