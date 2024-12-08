#!/bin/bash

echo "$1 average for original"
./average_metric_in_file.sh "$1" original_metrics.txt

echo "$1 average for optimized"
./average_metric_in_file.sh "$1" optimized_metrics.txt

echo "$1 average for manually optimized"
./average_metric_in_file.sh "$1" manually_optimized_metrics.txt