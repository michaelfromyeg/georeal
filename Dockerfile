FROM python:3.11-slim

WORKDIR /app

COPY . .
COPY --chmod=+x ./scripts/server-entrypoint.sh .

RUN apt-get update && \
    apt-get install -y git && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements/prod.txt && \
    adduser --disabled-password --gecos '' thekid && \
    chown -R thekid:thekid /app && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER thekid

ENV FLASK_APP=georeal.server

EXPOSE 5000

ENTRYPOINT ["/app/server-entrypoint.sh"]
