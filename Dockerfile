FROM python:3.10-slim

WORKDIR /app
COPY . .
RUN pip install --upgrade pip && pip install reflex
RUN reflex export --no-run
EXPOSE 3000
CMD ["reflex", "run", "--env", "production", "--port", "3000"]
