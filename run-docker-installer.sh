
#!/bin/bash
# Script to install docker on a remote Ubuntu instance

if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP_ADDRESS=$1

ssh -i alumnos.pem ubuntu@$IP_ADDRESS 'bash -s' < install-docker.sh