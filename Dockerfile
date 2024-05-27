
# Use the official Node.js 14 image as the base image.
FROM node:alpine3.18

# Set the working directory to /app
WORKDIR /app

# Install Nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# Copy custom Nginx configuration file to the container
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy the current directory contents into the container at /app
COPY package*.json /app

# Install any needed packages specified in package.json
RUN npm install


COPY . .

# Make port 8080 available to the world outside this container
EXPOSE 4000

# Run the app when the container launches
CMD ["npm", "run", "start"] 
