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

# 5. Install Oh My Zsh & Powerline (The ClaudeBox Shell Experience)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Change default shell to zsh
RUN chsh -s $(which zsh)

# 6. Configure SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# 7. Workspace Setup
WORKDIR /root/project

# 8. Add persistent history for Zsh (so you don't lose command history on restart)
RUN echo 'export HISTFILE=/root/project/.zsh_history' >> /root/.zshrc
RUN echo 'export HISTSIZE=10000' >> /root/.zshrc
RUN echo 'export SAVEHIST=10000' >> /root/.zshrc

# 9. Startup Script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
