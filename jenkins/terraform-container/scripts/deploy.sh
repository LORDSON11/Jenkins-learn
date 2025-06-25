#!/bin/bash

EC2_IP=$(cd ../infra && terraform output -raw public_ip)

docker save myapp:latest | bzip2 | ssh -o StrictHostKeyChecking=no -i ~/.ssh/node.pem ubuntu@$EC2_IP 'bunzip2 | docker load'

ssh -o StrictHostKeyChecking=no -i ~/.ssh/node.pem ubuntu@$EC2_IP << EOF
  docker stop myapp || true
  docker rm myapp || true
  docker run -d -p 80:80 --name myapp myapp:latest
EOF
