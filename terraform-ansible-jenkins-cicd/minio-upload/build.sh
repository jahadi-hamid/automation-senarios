#!/bin/bash

git clone https://github.com/jahadi-hamid/automation-senarios.git

export {http,https}_proxy=http://78.157.56.123:3128/
echo "****************************"
echo "** Building Docker Image ***"
echo "****************************"


cd automation-senarios/terraform-ansible-jenkins-cicd/minio-upload/ && docker-compose -f docker-compose.yml build --no-cache && docker-compose up -d
