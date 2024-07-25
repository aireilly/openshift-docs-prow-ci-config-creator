#!/bin/bash
# ./update-prow-config-branches.sh expects branches.csv in the currect dir

while IFS=, read -r BRANCH VERSION DISTROS; do
    export VERSION BRANCH DISTROS
    if [ -z "$VERSION" ] || [ -z "$BRANCH" ] || [ -z "$DISTROS" ]; then
        echo "The CSV file is missing data for one or more columns. Provide values for \$VERSION, \$BRANCH, \$DISTROS variables."
        exit 1
    fi

    template="openshift-openshift-docs-BRANCH.yaml"
    new_prow_config="openshift-openshift-docs-${BRANCH}.yaml"

    # Check if the template file exists
    if [ ! -f "$template" ]; then
        echo "Template file $template does not exist."
        continue
    fi

    mkdir -p out
    # Create a new Prow config
    envsubst < "$template" > "out/$new_prow_config"

    echo "New Prow config created: $new_prow_config"
done < branches.csv
