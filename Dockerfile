FROM node:10
RUN wget https://github.com/rearc/quest/archive/master.zip
RUN unzip quest-master.zip
WORKDIR /quest
RUN npm install
EXPOSE 3000
ENV SECRET_WORD TwelveFactor
CMD ["npm", "start"]
