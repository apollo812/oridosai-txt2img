FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=app

# Install necessary system libraries
RUN apt-get update && apt-get install -y libgl1-mesa-glx

# Create a non-root user
RUN useradd -ms /bin/bash user

# Set the working directory
WORKDIR /app

# Change ownership of the working directory to the non-root user
RUN chown -R user /app

# Switch to the non-root user
USER user

# Create directory and set permissions
RUN mkdir -p /app/.cache/huggingface && \
    chmod -R 777 /app/.cache/huggingface

# Nginx Setting

COPY ./config/config.json /docker-entrypoint.d/config.json

# Create folder named build for our app.

RUN mkdir build

# Copy the app folder to the /build

COPY . ./build

RUN /bin/sh -c apt update && apt install -y python3-pip                                  \
    && pip3 install -r /build/requirements.txt                               \
    && apt remove -y python3-pip                                              \
    && apt autoremove --purge -y                                              \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# Instruction informs Docker that the container listens on port 8000

EXPOSE 8000