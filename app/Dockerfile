FROM node:alpine
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE 8080
CMD [ "node", "index.js" ]
