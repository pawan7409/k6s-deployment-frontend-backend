# Build stage
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build:prod

# Production stage
FROM node:18-alpine

WORKDIR /app

RUN npm install -g @angular/cli

COPY --from=builder /app/dist/angular-frontend ./dist/angular-frontend

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0", "--poll", "2000"]
