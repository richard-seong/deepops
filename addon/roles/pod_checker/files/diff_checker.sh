#!/bin/bash

grep "<" diff | while read -r line ; do
        kind=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | awk '{print $3}')
        namespace=$(echo "$line" | awk '{print $4}')


        filename="$kind-$name-$namespace.json"

        echo "------------------------------- Diff Result ----------------------------------"
        echo "Kind: $kind"
        echo "Name: $name"
        echo "Namespace: $namespace"
        printf "\n"

        diff ./raw/before/$filename ./raw/after/$filename

        printf "\n\n"
done
