#!/bin/bash

set -x
IP=$(ip route show |grep -o src.* |cut -f2 -d" ")

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
zone=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
az_letter=${zone: -1}

export CODE_HASH="$(cat code_hash.txt)"
export IP
export AZ="${IP} in AZ-${az_letter}"
export zone

# exec container command
exec node server.js
