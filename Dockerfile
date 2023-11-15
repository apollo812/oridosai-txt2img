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
WORKDIR /home/user

ENV \
    PATH="/home/user/.local/bin:/home/user/.venv/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Nginx Setting
COPY --chown=user:user ./config/config.json /docker-entrypoint.d/config.json

# Copy the app folder to /home/user
COPY . /home/user

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /home/user/requirements.txt && \
    rm -rf /home/user/.cache/pip/*

# Expose port
EXPOSE 8000
