# Rearc Quest Dockerfile and Terraform Templates | Derek Wolpert

## Overview

The Dockerfile and Terraform templates in this repository make it possible to create and deploy a "dockerized" version of the React Quest application entirely through AWS services. In order to create these resources within your AWS account, both groupings of Terraforms files (``terraform_phase_one`` & ``terraform_phase_two``) are needed, as well as properly installed Terraform and AWS CLI resources with approiate IAM role access.

### Phase One

Creates a Codebuild project that imports this GitHub repo's latest master branch commit. The included ``buildspec.yml`` and ``Dockerfile`` direct Codebuild to create a Docker image from the latest build of the Rearc Quest application, and pushes the resulting Docker image into a ECR repository for storage and deployment in phase two.

### Phase Two

Creates a ECS cluster - along with container, task, and service definitions, and basic auto scaling configuration - to run the "dockerized" version of the Rearc Quest application. The ECS cluster is routed through a VPC and Loadbalancer with neccessary security grouping access (including a self-signed SSL certificate for "mock" HTTPS access) to allow the running container to be accessible on a public facing DNS url.

## Prerequisites

* Terraform version 0.12 (or greater) installed.
* AWS CLI installed with appropiate IAM role access (e.g. Codebuild, ECR, ECS, logs, etc.).
* AWS access key and secret key installed their default location, or Terraform configured to know where to find valid credentials.
* The GitHub webhook connection within the Codebuild project in phase one requires OAuth permissions to be granted. Even though the GitHub repo used for this project is public, you might need to manually grant your AWS account access to GitHub. You can read more about this feature here: https://www.terraform.io/docs/providers/aws/r/codebuild_webhook.html.

## Installation / Setup Instructions


### Part 1
1) Download the ``terraform_phase_one`` and ``terraform_phase_two`` directories onto your local device.

### Part 2
1) Navigate a terminal window to the ``terraform_phase_one`` directory.
2) Run the command ``terraform init`` to initalize the needed Terraform configuration files into the working directory. 
3) Run the command ``terraform plan`` to review an overview of resources to be created. If there is an issue with the given files Terraform will warn you to correct those issues before proceeding.
4) Run the command ``terraform apply`` to create the resources detailed in the working directory's Terraform files.

### Part 3
1) In a terminal window run the command ``aws codebuild start-build --project-name rearc-quest-codebuild-project`` to instruct your AWS account to create a build
* NOTE - It can take 2-5 mins for the build process to be completed. While waiting for the build to propagate to the previously created ECR repo, this may be a great time to use the bathroom or take a snach break. Only proceed to Part 4 when you have confirmed that a Docker image has been stored in the ECR repository - otherwise Part 4 will fail.

### Part 4
1) Navigate a terminal window to the ``terraform_phase_two`` directory.
2) Repeat the ``terraform init``, ``terraform plan`` and ``terraform apply`` process detailed in Part 2 to create the needed AWS resources.
* Note - It will take a few minutes for these resources to be created. Both a HTTP and HTTPS url/DNS directed towards the project's loadbalancer will be outputted when Terraform finishes. It will take a few more minutes for the running Docker container on the ECS cluster to be publicly accesible through either the HTTP or HTTPS url.

## Limitations

## Possible Improvements

## Contact Information

