FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=api

# Install necessary system libraries
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --gid 1000 user && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

# Switch to the non-root user
USER user

# Set the working directory
WORKDIR /build

# Nginx Setting
COPY --chown=user:user ./config/config.json /docker-entrypoint.d/config.json

# Copy the app folder to /build
COPY . /build

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /build/requirements.txt && \
    rm -rf /build/.cache/pip/*

# Expose port
EXPOSE 8000
