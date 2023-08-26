# Dockerfile
FROM python:3.11-stretch

RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential

COPY . /app
WORKDIR /app

RUN pip install -r requirements/prod.txt

CMD ["flask", "run"]
