# Use an official Node.js runtime as a base image for the backend
FROM node:14-alpine as backend

# Set the working directory for the backend
WORKDIR /app/backend

# Copy package.json and package-lock.json for backend and install dependencies
COPY backend/package*.json ./
RUN npm install

# Copy the rest of the backend code
COPY backend/ .

# Build the backend
RUN npm run build

# Use an official Node.js runtime as a base image for the frontend
FROM node:14-alpine as frontend

# Set the working directory for the frontend
WORKDIR /app/frontend

# Copy package.json and package-lock.json for frontend and install dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend code
COPY frontend/ .

# Build the frontend
RUN npm run build

# Use Nginx as the base image for the production image
FROM nginx:alpine

# Copy the built backend and frontend into the Nginx HTML directory
COPY --from=backend /app/backend/build /usr/share/nginx/html/api
COPY --from=frontend /app/frontend/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run the nginx server
CMD ["nginx", "-g", "daemon off;"]
