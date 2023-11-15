FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=api

# Install necessary system libraries
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd --gid 1000 ${PROJECT} && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 ${PROJECT}

# Switch to the non-root user
USER ${PROJECT}

# Set the working directory
WORKDIR /home/${PROJECT}

ENV \
    PATH="/home/${PROJECT}/.local/bin:/home/${PROJECT}/.venv/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# Nginx Setting
COPY --chown=${PROJECT}:${PROJECT} ./config/config.json /docker-entrypoint.d/config.json

# Copy the app folder to /home/${PROJECT}
COPY . /home/${PROJECT}

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /home/${PROJECT}/requirements.txt && \
    rm -rf /home/${PROJECT}/.cache/pip/*

# Expose port
EXPOSE 8000
