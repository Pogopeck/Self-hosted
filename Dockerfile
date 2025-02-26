# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    jq \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip

WORKDIR /home/runner

# Download and extract the runner
RUN curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.285.0/actions-runner-linux-x64-2.285.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64.tar.gz && \
    rm actions-runner-linux-x64.tar.gz

# Install dependencies while still root
RUN ./bin/installdependencies.sh

# Create a user for the runner
RUN useradd -m runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Copy entrypoint script
COPY entrypoint.sh /home/runner/entrypoint.sh

# Set permissions and ownership
RUN chmod +x /home/runner/entrypoint.sh && \
    chown -R runner:runner /home/runner

# Switch to the runner user
USER runner
WORKDIR /home/runner

# Set the entrypoint
ENTRYPOINT ["/home/runner/entrypoint.sh"]
