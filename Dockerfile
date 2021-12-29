FROM node:17-alpine3.12 AS base

# Create app directory
RUN mkdir -p /app
WORKDIR /app

ARG NEXT_PUBLIC_APP_VERSION
ENV NEXT_PUBLIC_APP_VERSION=${NEXT_PUBLIC_APP_VERSION}

# Installing dependencies
COPY package*.json .
RUN npm i

# Copying source files
COPY . /app

FROM base AS build

# Building app
RUN npm run build && npm prune --production
EXPOSE 3000

CMD ["npm", "run", "start"]