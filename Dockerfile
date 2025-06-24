FROM python:3.10-slim

WORKDIR /app
COPY . .

RUN pip install --upgrade pip && pip install reflex

EXPOSE 3000

CMD ["reflex", "run", "--env", "production", "--backend-port", "3000"]
