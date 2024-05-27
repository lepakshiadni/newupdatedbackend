# Use the official Node.js 14 image as the base image.
FROM node:14-alpine

# Install Apache2
RUN apk update && \
    apk add apache2 && \
    rm -rf /var/cache/apk/*

# Copy the current directory contents into the container at /app
WORKDIR /app
COPY package*.json /app

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the application code
COPY . .

# Make port 4000 available to the world outside this container
EXPOSE 4000

# Make port 80 available to the world outside this container for Apache
EXPOSE 80

# Configure Apache
RUN mkdir -p /run/apache2 && \
    echo "ServerName localhost" >> /etc/apache2/httpd.conf && \
    sed -i 's|^DocumentRoot ".*"|DocumentRoot "/app/public"|' /etc/apache2/httpd.conf && \
    sed -i 's|^<Directory ".*"|<Directory "/app/public">|' /etc/apache2/httpd.conf && \
    echo "ProxyPass / http://localhost:4000/" >> /etc/apache2/httpd.conf && \
    echo "ProxyPassReverse / http://localhost:4000/" >> /etc/apache2/httpd.conf

# Start Apache and then the Node app
CMD ["sh", "-c", "httpd && npm run start"]
