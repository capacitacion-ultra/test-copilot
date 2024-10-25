#!/bin/bash

# Script to install docke on Ubuntu
sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker ubuntu