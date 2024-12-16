# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:latest as build-stage

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY ./ /app/

ARG VITE_API_URL=${VITE_API_URL}

RUN npm run test

RUN npm run build


# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:latest

COPY --from=build-stage /app/dist/ /usr/share/nginx/html/

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
