FROM node:10
RUN wget https://github.com/rearc/quest/archive/master.zip
RUN unzip master.zip
RUN rm -rf master.zip
RUN mv /quest-master/* .
RUN rm -rf /quest-master
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
EXPOSE 3000
ENV SECRET_WORD TwelveFactor
CMD ["npm", "start"]
