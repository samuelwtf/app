FROM python:3.12

ENV REDIS_URL=

WORKDIR /app
COPY . .

RUN pip install -r requirements.txt

ENTRYPOINT ["reflex", "run", "--env", "prod", "--backend-only", "--loglevel", "debug" ]
