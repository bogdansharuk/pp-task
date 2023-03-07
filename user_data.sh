#!/bin/bash

### Install all dependencies and docker
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release jq
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker ubuntu

### Generate nginx whitelist
mkdir -p /home/ubuntu/nginx/
wget https://ip-ranges.amazonaws.com/ip-ranges.json -O /tmp/aws-ip-ranges.json
jq -r '.prefixes[] | select(.service=="EC2" or .service=="CLOUDFRONT") | .ip_prefix' < /tmp/aws-ip-ranges.json > /tmp/aws-ip-ranges-filtered.txt
echo "### Set real IP header" > /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "real_ip_header X-Forwarded-For;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "real_ip_recursive off;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "set_real_ip_from 10.10.0.0/16;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "### Allow ALB traffic" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "allow 10.10.0.0/16;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
echo "### Allow EC2 and CLOUDFRONT traffic only" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf
while read -r line;
do
  echo "allow $line;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf;
done < /tmp/aws-ip-ranges-filtered.txt
echo "deny all;" >> /home/ubuntu/nginx/nginx-aws-whitelist.conf;

### Generate index.html
ip=$(curl ifconfig.me)
cat <<EOF > /home/ubuntu/nginx/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>NGINX</title>
  </head>
  <body>
    <h1>Hello World!<h1>
    <h2>Instance public IP - $ip<h2>
  </body>
</html>
EOF

### Run docker container with custom configs
docker run -itd --restart=always -p 80:80 -v /home/ubuntu/nginx/index.html:/usr/share/nginx/html/index.html -v /home/ubuntu/nginx/nginx-aws-whitelist.conf:/etc/nginx/conf.d/nginx-aws-whitelist.conf nginx:latest
