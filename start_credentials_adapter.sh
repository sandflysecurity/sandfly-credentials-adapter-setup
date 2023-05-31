#!/usr/bin/env bash
# Sandfly Security LTD www.sandflysecurity.com
# Copyright (c) 2022-2023 Sandfly Security LTD, All Rights Reserved.

# Make sure we run from the correct directory so relative paths work
cd "$( dirname "${BASH_SOURCE[0]}" )"

VERSION=${CREDENTIAL_VERSION:-$(cat VERSION)}
IMAGE_BASE=${SANDFLY_IMAGE_BASE:-quay.io/sandfly}

# Use valid (#m or #g) env variable, otherwise the Sandfly default.
if  [[ "${SANDFLY_LOG_MAX_SIZE}" =~ ^[1-9][0-9]*[m|g]$ ]]; then
  LOG_MAX_SIZE=${SANDFLY_LOG_MAX_SIZE}
else
  LOG_MAX_SIZE="100m"
fi

docker network create sandfly-net 2>/dev/null
docker rm sandfly-credentials-adapter 2>/dev/null

docker run -v /dev/urandom:/dev/random:ro \
--disable-content-trust \
--restart=always \
--security-opt="no-new-privileges:true" \
--network sandfly-net \
--name sandfly-credentials-adapter \
--label sandfly-credentials-adapter \
--user sandflyserver:sandfly \
--log-driver json-file \
--log-opt max-size=${LOG_MAX_SIZE} \
--log-opt max-file=5 \
-v $(pwd)/conf:/opt/sandfly/conf:ro \
-d $IMAGE_BASE/sandfly-credentials-adapter${IMAGE_SUFFIX}:"$VERSION"

exit $?
