FROM node:20-alpine

ENV NODE_ENV=production \
    PORT=8000

WORKDIR /app

# Instalar dependencias necesarias
RUN apk add --no-cache git python3 make g++ yarn

# Clonar Coolify desde GitHub o tu propio fork
RUN git clone https://github.com/coollabsio/coolify.git . \
    && yarn install --frozen-lockfile \
    && yarn build

EXPOSE 8000

CMD ["yarn", "start"]
