FROM node:20 AS build
WORKDIR /vishnu
COPY package*.json ./
RUN npm install --legacy-peer-deps
RUN npm install -g npm@latest
RUN npm install -g @medusajs/medusa-cli
COPY . .
RUN npm run migrate
RUN npm run build
RUN npm run build:server
RUN npx medusa-admin build
FROM node:20
WORKDIR /vishnu
COPY --from=build /vishnu /vishnu
ENV NODE_ENV=development
ENV DATABASE_URL=postgres://postgres:vishnuvishnu@postgres/medusa-pby2
ENV REDIS_URL=redis://redis:6379
ENV PORT=9000
EXPOSE 9000
CMD ["sh", "-c", "npx medusa start && node --preserve-symlinks --trace-warnings index.js"]