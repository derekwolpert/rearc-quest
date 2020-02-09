# Defines the base image to use to start the build process
FROM node:10
# Sets the working directory
WORKDIR /app
# Copies the package.json into the working directory
COPY package.json /app
# Executes the install command
RUN npm install
# Copies application files to the working directory
COPY . /app
# Specfifes port that will be exposed for given container 
EXPOSE 3000
# Defines environment variables that are avaiable within the container
ENV SECRET_WORD TwelveFactor
# Executes the start command
CMD ["npm", "start"]