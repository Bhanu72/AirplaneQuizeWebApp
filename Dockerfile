FROM node:alpine3.18 as build

WORKDIR /app

COPY package*.json ./

RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.24.0-alpine-slim
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf", "-p", ".", "-a", "8080;"]

