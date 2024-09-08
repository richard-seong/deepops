#!/bin/bash
resources=$(kubectl api-resources --verbs=list -o name | grep -iv event)

mid_result=$(echo "$resources" | \
        xargs -n 1 kubectl get -A \
                        --no-headers \
                        --show-kind \
                        --ignore-not-found \
                        -o go-template='{{range .items}}{{.kind}} {{.metadata.name}} {{if .metadata.namespace}}{{.metadata.namespace}}{{else}}default{{end}}{{"\n"}}{{end}}' 2> /dev/null)

result=$(echo "$mid_result" | \
        sed 's/NetworkAttachmentDefinition/network-attachment-definitions/')

result=$(echo "$result" | \
        xargs -n 3 bash -c 'kubectl get --no-headers $0 $1 -n $2 -o json 2> /dev/null' | \
        jq -r '[.kind, .metadata.name, .metadata.namespace, .metadata.resourceVersion, .metadata.creationTimestamp, .status.startTime] | @tsv')


if ! [ -z "$1" ]
then
        printf "Executed at $(date '+%Y-%m-%d %H:%M:%S')\n\n" > $1
        printf "$mid_result\n\n" >> $1
        echo "------------------------------------------------------------------------------" >> $1
        printf "\n\n$result" >> $1
else
        echo "$result"
fi

#kubectl get all -A -ojson > t1.json
#kubectl get pv -ojson > t2.json
#kubectl get pvc -A -ojson > t3.json
#kubectl get customresourcedefinitions.apiextensions.k8s.io -A -ojson > t4.json
#kubectl get volumeattachments.storage.k8s.io -A -ojson > t5.json

#cat t1.json t2.json t3.json t4.json t5.json > _$1
#jq 'del(.items[].metadata)' _$1 | jq 'del(.items[].status)' | jq 'del(.items[] | select(.kind == "Revision"))' > $1

#rm t1.json t2.json t3.json t4.json t5.json _$1
