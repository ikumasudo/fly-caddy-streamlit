ARG PYTHON_VERSION=3.10-slim-bullseye
FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install necessary tools and Caddy
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    debian-keyring \
    debian-archive-keyring \
    apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt-get update \
    && apt-get install -y caddy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install poetry and project dependencies
RUN pip install --no-cache-dir poetry

COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-root --no-interaction --no-cache

COPY . .
COPY Caddyfile /etc/caddy/Caddyfile

CMD ["/bin/bash", "./start.sh"]