# MinIO cluster (made by Github copilot)

This tutorial will explain step to step the installation and configuration of a minio cluster made in AWS and then, we will create a Pythos REST endpoint for getting the text from an image or PDF and strore that file in the MinIO cluster and generate a signed url valid for 2 hours.

## Step 1 (create the cluster nodes)

Since you have installed the AWS CLI, create a file named 'create-aws-nodes.sh' with the following content:

```bash
#!/bin/bash

# Script to create 3 EC2 instances of type t2.medium using AWS CLI
aws ec2 run-instances \
--image-id ami-0866a3c8686eaeeba \
--count 5 \
--instance-type t2.medium \
--key-name alumnos \
--security-group-ids sg-0c90571d85b73b152 \
--subnet-id subnet-2b8ff405
````
This will create 5 EC2 instances in AWS EC2. Each of them will be t2.medium and will be accesible with a private key named (inside of AWS) 'alumnos'.

## Install docker
Now, lets install docker in every node. First at all, create a bash file like this:

```bash
#!/bin/bash

# Script to install docker on Ubuntu
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker ubuntu
````

Now, for every new node, execute this:

`cat install-docker.sh | ssh -i alumnos.pem ubuntu@18.206.114.55 'bash -'`

> Just replace the 18.206.114.55 ip for the right one in each case

## Instal MinIO cluster
Now, with docker installed in every node, install a dockerizwed version of MinIO in every node. For this, use this 2 scripts:

minio-cluster-setup.sh :

```bash
#!/bin/bash

# *****************************************************
# Script to create a MinIO cluster with multiple nodes
# *****************************************************

# Stop and remove the existing MinIO container
docker stop minio
docker rm minio

# Check if at least one argument (IP address) is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <IP1> <IP2> ... <IPn>"
  exit 1
fi

# Environment variables for MinIO (adjust these if needed)
MINIO_ROOT_USER="admin"
MINIO_ROOT_PASSWORD="UrbiEtOrbi1_"
mkdir -p ~/minio-data

# Construct the MinIO server command with all IP addresses
SERVER_CMD="minio/minio server"

for ip in "$@"; do
  SERVER_CMD="$SERVER_CMD http://$ip/data"
done

# Run the Docker command
docker run -d \
  --name minio \
  -v ~/minio-data:/data \
  -e "MINIO_ROOT_USER=$MINIO_ROOT_USER" \
  -e "MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD" \
  --net=host \
  $SERVER_CMD --console-address ":9001"

# Print the executed command for verification
echo "Executed Docker command:"
echo "docker run -d --name minio -p $API_PORT:$API_PORT -p $CONSOLE_PORT_DOCKER:$CONSOLE_PORT -v ~/minio-data:/data -e MINIO_ROOT_USER=$MINIO_ROOT_USER -e MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD $SERVER_CMD  --console-address ':9001'"
````
the following script (startup-minio-cluster.sh) invokes the previous one, and spin off the cluster:

```bash
./minio-cluster-setup.sh \
172.31.86.174 \
172.31.91.164 \
172.31.87.144 \
172.31.82.73
```
Just copy the 2 previous scripts to each server:

```bash
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@54.175.150.200:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@52.202.217.13:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@18.206.114.55:/home/ubuntu
scp -i alumnos.pem minio-cluster-setup.sh ubuntu@34.201.136.104:/home/ubuntu

scp -i alumnos.pem startup-minio-cluster.sh ubuntu@54.175.150.200:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@52.202.217.13:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@18.206.114.55:/home/ubuntu
scp -i alumnos.pem startup-minio-cluster.sh ubuntu@34.201.136.104:/home/ubuntu
```

## End Installation

Go to each server and run: ./startup-minio-cluster.sh

## create a load-balancer + reverse proxy service in Nginx:

Create a file named 'balancer.conf' with this content:

```text
upstream cluster {
    server 54.175.150.200:9001;
    server 52.202.217.13:9001;
    server 18.206.114.55:9001;
    server 34.201.136.104:9001;
}

server {
    server_name minio.ultrasist.net;

    client_max_body_size 5G;

    # Timeouts and buffer settings for handling large uploads
    client_body_timeout 300s;
    send_timeout 300s;
    
    client_body_buffer_size 128k;
    proxy_buffer_size 128k;
    proxy_buffers 16 128k;
    proxy_busy_buffers_size 256k;

    location / {
        proxy_pass http://cluster;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }

    include common/ssl-ultrasist.conf;
    include common/error.conf;
    include common/last.conf;
}
````

Please, note that the IP's in the section "server" are the públic IP's for each node.
