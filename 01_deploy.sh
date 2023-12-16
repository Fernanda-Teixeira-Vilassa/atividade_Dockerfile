#!/bin/bash -e

STUDENT="fernanda"
cd jenkins
IMAGE_NAME="${STUDENT}/jenkins"
IMAGE_VERSION=$(($(cat version)+1))
IMAGE_FULLNAME="$IMAGE_NAME:$IMAGE_VERSION"

# Docker
export DOCKER_BUILDKIT=1
docker build . -t $IMAGE_FULLNAME

# Update version file
echo $IMAGE_VERSION > version

echo -e "\n\nImage ${IMAGE_FULLNAME} built."

# Run the Docker container
docker run -p 8080:8080 $IMAGE_FULLNAME
