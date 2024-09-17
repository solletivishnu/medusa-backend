# Use an official Node.js runtime as a parent image
FROM node:20 AS build

# Set the working directory in the container
WORKDIR /vishnu

# Copy package.json and package-lock.json for npm install
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

RUN npm install -g npm@latest

# Install Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

# Copy the rest of the application code
COPY . .

# Run database migrations
RUN npm run migrate

# Build the project
RUN npm run build

# Build the server and admin UI
RUN npm run build:server
RUN npx medusa-admin build
RUN npm run seed

# Use a smaller base image for the final build
FROM node:20

# Set the working directory in the container
WORKDIR /vishnu

# Copy the built files from the previous stage
COPY --from=build /vishnu /vishnu

# Set environment variables
ENV NODE_ENV=production
ENV DATABASE_URL=postgres://postgres:vishnuvishnu@postgres/medusa-pby2
ENV REDIS_URL=redis://redis:6379
ENV PORT=9000

# Expose the application ports
EXPOSE 9000
EXPOSE 7001

# Start Medusa and then your custom Node.js process
ENTRYPOINT ["sh", "-c", "npx medusa migrations run && npx medusa start & node --preserve-symlinks --trace-warnings index.js"]
