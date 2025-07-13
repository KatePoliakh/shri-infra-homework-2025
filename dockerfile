FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY .npmrc ./

RUN npm ci

COPY . .

RUN npm run build

RUN npm prune --production

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

COPY --from=builder /app/dist ./dist

COPY --from=builder /app/src/server ./src/server
COPY --from=builder /app/src/common ./src/common  

COPY --from=builder /app/tsconfig.json ./
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["npm", "start"]