FROM node:20-slim AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci


COPY . .

# Point the API at the backend before building
ARG API_URL=/api
#RUN sed -i "s|https://conduit.productionready.io/api|${API_URL}|g" \
#      src/app/core/interceptors/api.interceptor.ts

RUN sed -i "s|https://api.realworld.io/api|${API_URL}|g" \
      src/app/core/interceptors/api.interceptor.ts


RUN npm run build

# ---- Serve stage ----
FROM nginx:alpine

COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]