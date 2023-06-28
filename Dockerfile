FROM python:3.10 AS lean

RUN apt-get update -y && apt install libpq-dev
RUN pip install --upgrade pip
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
WORKDIR /app/kingfisher-collect
RUN pip install -r requirements.txt
WORKDIR /app