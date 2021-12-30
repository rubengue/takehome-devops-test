FROM node:17-alpine3.12 AS build

# Create app directory
RUN mkdir -p /app
WORKDIR /app


# Installing dependencies
COPY package*.json .
RUN npm i

# Copying source files
COPY . /app

ARG NEXT_PUBLIC_APP_VERSION
ENV NEXT_PUBLIC_APP_VERSION=${NEXT_PUBLIC_APP_VERSION}

RUN npm run build
RUN npm prune --production

FROM node:17-alpine3.12 AS production
WORKDIR /app



COPY --from=build /app/node_modules node_modules 
COPY --from=build /app/pages pages 
COPY --from=build /app/public public
COPY --from=build /app/styles styles 
COPY --from=build /app/.next .next
COPY --from=build /app/package.json .
COPY --from=build /app/next.config.js .



# Building app
EXPOSE 3000

CMD ["npm", "run", "start"]