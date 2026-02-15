FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 python3.11-venv python3.11-dev python3-pip \
    git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# Make python3.11 the default python
RUN ln -sf /usr/bin/python3.11 /usr/bin/python

# Copy dependency files first (better layer caching)
COPY pyproject.toml uv.lock README.md /app/

# Copy repo before uv sync so workspace is present
COPY . /app

# Install uv and sync deps
RUN python -m pip install --no-cache-dir uv \
    && uv sync

# Default entrypoint
ENTRYPOINT ["uv", "run", "DOPAMINE.py"]