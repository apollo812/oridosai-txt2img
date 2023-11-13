FROM nginx/unit:1.28.0-python3.10 as base

ARG PROJECT=app

# Nginx Setting

COPY ./config/config.json /docker-entrypoint.d/config.json

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

FROM base as dev

COPY --chown=user:user ./$PROJECT /build/$PROJECT

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

FROM base as test

# Default target.
FROM dev
