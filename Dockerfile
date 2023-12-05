# Build Stage
FROM node:alpine3.18 as build

WORKDIR /app

COPY package*.json ./

RUN npm install
COPY . .
RUN npm run build

# Production Stage
FROM nginx:1.24.0-alpine-slim

# Copy the built React app from the build stage to the Nginx web server directory
COPY --from=build /app/build /usr/share/nginx/html

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
