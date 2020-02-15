FROM node:10
RUN wget https://github.com/rearc/quest/archive/master.zip
RUN unzip master.zip
WORKDIR /quest-master/app
COPY /quest-master/package.json /quest-master/app
RUN npm install
COPY /quest-master/. /app
EXPOSE 3000
ENV SECRET_WORD TwelveFactor
CMD ["npm", "start"]
