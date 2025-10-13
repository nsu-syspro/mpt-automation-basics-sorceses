FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    gcc \
    make \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app

RUN make check

ENTRYPOINT ["./build/wordcount"]
