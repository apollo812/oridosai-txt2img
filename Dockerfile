# Start from the base image
FROM nginx/unit:1.28.0-python3.10 as base

# Set the working directory
WORKDIR /home/user

# Install necessary system libraries
USER root
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*
USER user

# Set environment variables
ENV PATH="/home/user/.local/bin:/home/user/.venv/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Nginx Setting
COPY --chown=user:user ./config/config.json /docker-entrypoint.d/config.json

# Copy the app folder to the /app
COPY . /home/user

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /home/user/requirements.txt && \
    rm -rf /home/user/.cache/pip/*

# Expose port
EXPOSE 8080