FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=app

# Create a non-root user to run the app with.
RUN groupadd --gid 1000 user &&  adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user
USER user

# Create directory and set permissions
RUN mkdir -p /root/.cache/huggingface && \
    chmod -R 777 /root/.cache/huggingface

# Nginx Setting

COPY ./config/config.json /docker-entrypoint.d/config.json

# Install necessary system libraries
RUN apt-get update && apt-get install -y libgl1-mesa-glx

# Create folder named build for our app.

RUN mkdir build

# Copy the app folder to the /build

COPY . ./build

RUN apt update && apt install -y python3-pip                                  \
    && pip3 install -r /build/requirements.txt                               \
    && apt remove -y python3-pip                                              \
    && apt autoremove --purge -y                                              \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# Instruction informs Docker that the container listens on port 8000

EXPOSE 8000