#!/bin/bash
#ex) ./get_all_resources.sh before
RAW_DIR=./raw

resources=$(kubectl api-resources --verbs=list -o name | grep -iv -e event -e leases -e componentstatuses)

mid_result=$(echo "$resources" | \
        xargs -n 1 kubectl get -A \
                        --no-headers \
                        --show-kind \
                        --ignore-not-found \
                        -o go-template='{{range .items}}{{.kind}} {{.metadata.name}} {{if .metadata.namespace}}{{.metadata.namespace}}{{else}}default{{end}}{{"\n"}}{{end}}' 2> /dev/null)

result=$(echo "$mid_result" | \
        sed 's/NetworkAttachmentDefinition/network-attachment-definitions/')

if ! [ -z "$1" ]
then
       work_dir=$RAW_DIR/$1/
       mkdir -p $work_dir

       (cd $work_dir && \
               echo "$result" | xargs -n 3 bash -c 'kubectl get --no-headers $0 $1 -n $2 -o json 2> /dev/null 1> $0-$1-$2.json')

       result=$(cd $work_dir && \
               jq -r '[.kind, .metadata.name, .metadata.namespace // "default   ", .metadata.resourceVersion, .metadata.creationTimestamp, .status.startTime] | @tsv' *.json)


else
       result=$(echo "$result" | \
               xargs -n 3 bash -c 'kubectl get --no-headers $0 $1 -n $2 -o json 2> /dev/null' | \
               jq -r '[.kind, .metadata.name, .metadata.namespace, .metadata.resourceVersion, .metadata.creationTimestamp, .status.startTime] | @tsv')
fi



if ! [ -z "$1" ]
then
        printf "$result" >> $1
else
        echo "$result"
fi
