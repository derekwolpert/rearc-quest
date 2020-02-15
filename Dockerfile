# Defines the base image to use to start the build process
FROM node:10
# Sets the working directory for the project, in this case creates the directory since it did not previously exist
WORKDIR /app
# Downloads a zip file of the node.js app from the master branch
RUN wget https://github.com/rearc/quest/archive/master.zip
# Unzips the node.js app
RUN unzip master.zip
# Moves the contents of the unzipped node.js package into it's parent directory
RUN mv quest-master/* ./
# Deletes the downloaded zip file and previously emptied app directory
RUN rm -rf master.zip quest-master
# Executues the install command
RUN npm install
# Specfifes port that will be exposed for given container
EXPOSE 3000
# Defines environment variables that are avaiable within the container
ENV SECRET_WORD TwelveFactor
# Executes the start command
CMD ["npm", "start"]