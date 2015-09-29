#!/bin/sh
docker ps --no-trunc | awk 'BEGIN {FS=" {2,}"} NR > 1 {print $5, $7}'
