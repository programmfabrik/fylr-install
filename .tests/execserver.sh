#!/bin/bash

NAMESPACE="execserver"
number_replicas=$(kubectl -n $NAMESPACE get pods -l app=execserver | grep execserver | wc -l)

# check if replicas are alive
if [ "$number_replicas" != "3" ]; then
    echo "Replica count [ $number_replicas ] doesn't match expected number (3)."
    exit -1
fi

# check if all replicas are running
for i in {1..3}; do
    if [ "$(kubectl -n $NAMESPACE get pods -l app=execserver | grep execserver | awk '{print $3}' | grep Running | wc -l)" != "3" ]; then
        echo "Replica $i is not running."
        kubectl -n $NAMESPACE get pods -l app=execserver
        exit -1
    else 
        echo "Replica $i is running."
    fi
done