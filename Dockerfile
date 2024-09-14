# Use an official Node.js runtime as a parent image
FROM node:20 AS build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json for npm install
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

RUN npm install -g npm@latest

# Copy the rest of the application code
COPY . .

# Run database migrations
RUN npx medusa migrations run

# Build the project
RUN npm run build

# Build the server and admin UI
RUN npm run build:server
RUN npx medusa-admin build

# Use a smaller base image for the final build
FROM node:20

# Set the working directory in the container
WORKDIR /app

# Copy the built files from the previous stage
COPY --from=build /app /app

# Set environment variables
ENV NODE_ENV=production
ENV DATABASE_URL=postgres://postgres:vishnuvishnu@postgres/medusa-pby2
ENV REDIS_URL=redis://redis:6379
ENV PORT=9000  

# Expose the application ports
EXPOSE 9000  
EXPOSE 7001  

# Start the server
CMD ["node", "--preserve-symlinks", "--trace-warnings", "index.js"]






RUN npm install -g npm@latest