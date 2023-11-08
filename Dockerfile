FROM python:3.10 AS lean

RUN apt-get update -y && apt install -y libpq-dev && apt install -y postgresql-client
RUN pip install --upgrade pip
WORKDIR /app
COPY . .
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt
WORKDIR /app/kingfisher-collect
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt
WORKDIR /app/
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.12.1/wait /wait
RUN chmod +x /wait