#!/usr/bin/env bash
# Sandfly Security LTD www.sandflysecurity.com
# Copyright (c) 2022-2023 Sandfly Security LTD, All Rights Reserved.

# This script will shut down the Sandfly credentials adapter container.

credentialadapter=$(docker container ps -qf "name=sandfly-credentials-adapter")
if [[ -n "$credentialadapter" ]]; then
    echo "* Sandfly credentials adapter is running on this system. Stopping..."
    docker update --restart=no $credentialadapter
    docker stop $credentialadapter
    echo "* Sandfly credentials adapter stopped."
fi

printf "\n\n* Done.\n\n"
