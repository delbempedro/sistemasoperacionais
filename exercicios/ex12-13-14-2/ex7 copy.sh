#!/usr/bin/env bash
set -eou pipefail

url=$1

status=$( curl -s -o /dev/null -w "%{http_code}" "$url")

if [[ $status -ge 200 && $status -lt 400 ]]; then
    echo "The site $url is active (Status Code: $status)"
else
    echo "The site $url is inactive (Status Code: $status)"
fi