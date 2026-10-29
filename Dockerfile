FROM python:3.9-slim

LABEL maintainer="codercollo"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

WORKDIR /app
EXPOSE 8080

ARG DEV=false

RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  apt-get update && \
  apt-get install -y --no-install-recommends postgresql-client && \
  rm -rf /var/lib/apt/lists/* && \
  /py/bin/pip install -r /tmp/requirements.txt && \
  if [ "$DEV" = "true" ]; then \
  /py/bin/pip install -r /tmp/requirements.dev.txt; \
  fi && \
  rm -rf /tmp && \
  useradd --no-create-home django-user

COPY ./app /app

ENV PATH="/py/bin:$PATH"

USER django-user