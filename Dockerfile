FROM nginx/unit:1.28.0-python3.10

# Nginx Setting

COPY ./config/config.json /docker-entrypoint.d/config.json

# Create folder named build for our app.

RUN mkdir build

# We copy our app folder to the /build

COPY . ./build

RUN apt update && apt install -y python3-pip                                  \
    && pip3 install -r /build/requirements.txt                               \
    && apt remove -y python3-pip                                              \
    && apt autoremove --purge -y                                              \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list

# Instruction informs Docker that the container listens on port 8000

EXPOSE 8000




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
