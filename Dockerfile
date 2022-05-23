FROM node:16.14.2
COPY . .
RUN npm install
EXPOSE 3000
ENTRYPOINT [ "node", "index.js" ]
