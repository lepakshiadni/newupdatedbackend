# Use the official Node.js 14 image as the build stage
FROM node:14 AS build

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application (if there's a build step)
RUN npm run build

# Use the official Nginx image as the base for the production stage
FROM nginx:alpine

# Copy the built application from the build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy the Nginx configuration file from the config directory
COPY config/nginx.conf /etc/nginx/nginx.conf

# Expose port 4000
EXPOSE 4000

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]


# # Use the official Node.js 14 image as the base image.
# FROM node:alpine3.18 AS build

# # Set the working directory to /app
# WORKDIR /app

# # Copy the package.json and package-lock.json
# COPY package*.json ./

# # Install any needed packages specified in package.json
# RUN npm install

# # Copy the current directory contents into the container at /app
# COPY . .

# # Build the Node.js app (if necessary)
# # RUN npm run build

# # Use the official NGINX image for serving the application
# FROM nginx:alpine
# # Copy the built Node.js app from the build stage to the NGINX html directory
# # If you have a build step, replace `.` with the build output directory, e.g., `build`
# COPY --from=build /app /usr/share/nginx/html

# # Copy custom NGINX configuration file
# COPY nginx.conf /etc/nginx/nginx.conf

# # Copy additional NGINX configurations if any
# COPY conf.d /etc/nginx/conf.d

# # Expose port 80
# EXPOSE 80

# # Run NGINX
# CMD ["nginx", "-g", "daemon off;"]
