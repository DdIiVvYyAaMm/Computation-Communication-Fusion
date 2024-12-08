#!/bin/bash

# USE: ./average_metric_in_file.sh "metric name" file

cat $2 | grep "$1" | awk '{sum += $NF; count++} END {print sum / count}'