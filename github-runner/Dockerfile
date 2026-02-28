# Use Ubuntu as base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies required for GitHub Actions runner
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    sudo \
    libicu-dev \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Create a user for the runner
RUN useradd -m -s /bin/bash runner && \
    usermod -aG sudo runner && \
    usermod -aG docker runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory
WORKDIR /home/runner

# Download and extract GitHub Actions runner
RUN curl -o actions-runner-linux-x64-2.331.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.331.0/actions-runner-linux-x64-2.331.0.tar.gz && \
    echo "5fcc01bd546ba5c3f1291c2803658ebd3cedb3836489eda3be357d41bfcf28a7  actions-runner-linux-x64-2.331.0.tar.gz" | shasum -a 256 -c && \
    mkdir -p actions-runner && \
    tar xzf ./actions-runner-linux-x64-2.331.0.tar.gz -C actions-runner && \
    rm actions-runner-linux-x64-2.331.0.tar.gz && \
    chown -R runner:runner /home/runner

RUN ls -la /home/runner/actions-runner

# Copy the runner script
COPY runner.sh /home/runner/runner.sh

# Make the script executable
RUN chmod +x /home/runner/runner.sh && \
    chown runner:runner /home/runner/runner.sh

# Switch to runner user
USER runner

# Run the script
CMD ["/bin/bash", "/home/runner/runner.sh"]

