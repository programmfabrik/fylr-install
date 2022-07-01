#!/bin/bash

NAMESPACE="execserver"

function fn_print_deployment_information() {
    kubectl -n $NAMESPACE get deployment -l app=execserver
    echo "============================================================"
    kubectl -n $NAMESPACE get pods -l app=execserver -o json
    echo "============================================================"
    kubectl -n $NAMESPACE describe pods -l app=execserver
}


# wait for the deployment to be ready
kubectl -n $NAMESPACE wait deployment -l app=execserver --for condition=Available=True --timeout=120s

if [ "$?" != "0" ]; then
    echo "Deployment failed"
    fn_print_deployment_information
    exit 1
fi

number_replicas=$(kubectl -n $NAMESPACE get pods -l app=execserver | grep execserver | wc -l)

# check if replicas are match the desired number of replicas
if [ "$number_replicas" != "3" ]; then
    echo "Replica count [ $number_replicas ] doesn't match expected number (3)."
    exit 2
fi

# check if all replicas are running
for i in {1..3}; do
    if [ "$(kubectl -n $NAMESPACE get pods -l app=execserver | grep execserver | awk '{print $3}' | grep Running | wc -l)" != "3" ]; then
        echo "Replica $i is not running."
        fn_print_deployment_information
        exit 3
    else 
        echo "Replica $i is running."
    fi
done