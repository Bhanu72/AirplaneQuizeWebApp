# Use an official Node runtime as a base image
FROM node:14-alpine as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the remaining application files to the working directory
COPY . .

# Build the React app
RUN npm run build

# Use an official Nginx image as a base image for the production environment
FROM nginx:alpine

# Copy the built React app from the build stage to the Nginx web server directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the application
CMD ["nginx", "-g", "daemon off;"]
