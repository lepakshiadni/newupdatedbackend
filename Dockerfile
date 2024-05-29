# Stage 1: Build the Node.js application
FROM node:alpine3.18 AS build

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application
COPY . .

# Stage 2: Serve the Node.js application with Nginx
FROM nginx:1.23-alpine

# Copy static files from the build stage to Nginx's web root directory
COPY --from=build /app /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Default command to start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]






