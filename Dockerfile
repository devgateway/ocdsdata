FROM python:3.10 AS lean

RUN apt-get update -y && apt install libpq-dev
RUN pip install --upgrade pip
WORKDIR /app
COPY . .
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt
WORKDIR /app/kingfisher-collect
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt
WORKDIR /app/