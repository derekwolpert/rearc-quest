# Defines the base image to use to start the build process
FROM node:10
# Sets the working directory
RUN git clone https://github.com/rearc/quest.git
WORKDIR /quest
# Copies the package.json into the working directory
RUN npm install
# Copies application files to the working directory
EXPOSE 3000
# Defines environment variables that are avaiable within the container
ENV SECRET_WORD TwelveFactor
# Executes the start command
CMD ["npm", "start"]
