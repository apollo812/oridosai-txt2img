FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=app

# Install necessary system libraries
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
# RUN useradd -ms /bin/bash user
RUN groupadd --gid 1000 user &&  adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

# Switch to the non-root user
USER user

# Set the working directory
WORKDIR /app

# Change ownership of the working directory to the non-root user
RUN chown -R user /app

# Create directory and set permissions
RUN mkdir -p /app/.cache/huggingface && \
    chmod -R 755 /app/.cache/huggingface

# Nginx Setting
COPY ./config/config.json /docker-entrypoint.d/config.json

# Copy the app folder to the /app
COPY . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /app/requirements.txt && \
    rm -rf /app/.cache/pip/*

# Expose port
EXPOSE 8000