FROM node:10
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
EXPOSE 3000
ENV SECRET_WORD TwelveFactor
CMD ["npm", "start"]