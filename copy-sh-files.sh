#!/bin/bash

# Script to copy files to the EC2 instances of the Minio cluster
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@54.175.150.200:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@52.202.217.13:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@18.206.114.55:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@34.201.136.104:/home/ubuntu

scp -i alumnos.pem startup-minio-cluster.sh ubuntu@54.175.150.200:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@52.202.217.13:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@18.206.114.55:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@34.201.136.104:/home/ubuntu
