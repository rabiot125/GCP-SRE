FROM node:13.14.0-alpine AS builder

WORKDIR /app

COPY package.json ./

RUN npm install --production

COPY . .

RUN npm run build

# Start a new stage
FROM node:13.14.0-alpine

WORKDIR /app

COPY --from=builder /app ./

EXPOSE 3000

CMD ["npm", "start"]