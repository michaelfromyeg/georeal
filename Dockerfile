FROM python:3.11-slim

WORKDIR /app

COPY . .
COPY --chmod=+x ./scripts/server-entrypoint.sh .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements/prod.txt && \
    adduser --disabled-password --gecos '' thekid && \
    chown -R thekid:thekid /app

USER thekid

ENV FLASK_APP=georeal.server

EXPOSE 5000

ENTRYPOINT ["/app/server-entrypoint.sh"]
