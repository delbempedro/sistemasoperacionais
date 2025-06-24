#!/usr/bin/env bash
set -eou pipefail

url=$1

status=$( curl -s -o /dev/null -w "%{http_code}" "$url")