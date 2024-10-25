#!/bin/bash

# Script to create 3 EC2 instances of type t2.medium using AWS CLI
aws ec2 run-instances \
--image-id ami-0866a3c8686eaeeba \
--count 3 \
--instance-type t2.medium \
--key-name alumnos \
--security-group-ids sg-0c90571d85b73b152 \
--subnet-id subnet-2b8ff405
