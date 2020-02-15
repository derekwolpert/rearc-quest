FROM node:10
RUN wget https://github.com/rearc/quest/archive/master.zip
RUN unzip master.zip
RUN mv quest-master/* ./
RUN rm -rf master.zip quest-master
RUN npm install
EXPOSE 3000
ENV SECRET_WORD TwelveFactor
CMD ["npm", "start"]