FROM nginx/unit:1.28.0-python3.10 as base

COPY ./config/config.json /docker-entrypoint.d/config.json

# Ok, this is something we get thanks to the Nginx Unit Image.
# We don't need to call stuff like
# curl -X PUT --data-binary @config.json --unix-socket \
#       /path/to/control.unit.sock http://localhost/config/
# to set our configuration
# Becouse as stated in docs https://unit.nginx.org/installation/#docker-images,
# configuration snippets are 
# uploaded as to the config section of Unit’s configuration
# That means we only have to copy our config.json file to the folder
# /docker-entrypoint.d/

RUN mkdir /build

# We create folder named build for our app.

COPY . ./build

# We copy our app folder to the /build

RUN apt update && apt install -y python3-pip                                  \
    && pip3 install -r /build/requirements.txt                               \
    && apt remove -y python3-pip                                              \
    && apt autoremove --purge -y                                              \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# OK, that looks strange but here's a explanation from Nginx docs
# https://unit.nginx.org/howto/docker/:

# """ PIP isn't installed by default, so we install it first.
# Next, we install the requirements, remove PIP, and perform image cleanup. """

# Note we use /build/requirements.txt since this is our file

EXPOSE 8000

# Instruction informs Docker that the container listens on port 80






# ARG PROJECT=api

# # Install necessary system libraries
# RUN apt-get update && apt-get install -y \
#     libgl1-mesa-glx \
#     python3-pip && \
#     rm -rf /var/lib/apt/lists/*

# # Create a non-root user
# RUN groupadd --gid 1000 user && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 user

# # Switch to the non-root user
# USER user

# # Set the working directory
# WORKDIR /home/user

# ENV \
#     PATH="/home/user/.local/bin:/home/user/.venv/bin:${PATH}" \
#     PYTHONUNBUFFERED=1 \
#     POETRY_NO_INTERACTION=1 \
#     POETRY_VIRTUALENVS_IN_PROJECT=true

# # Nginx Setting
# COPY --chown=user:user ./config/config.json /docker-entrypoint.d/config.json

# # Copy the app folder to /home/user
# COPY . /home/user

# # Install Python dependencies
# RUN pip3 install --no-cache-dir -r /home/user/requirements.txt && \
#     rm -rf /home/user/.cache/pip/*

# # Expose port
# EXPOSE 8000
