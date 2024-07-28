REPOSITORY_NAME="redhat-lambda"
DOCKER_IMAGE="${REPOSITORY_NAME}:latest"

docker container run \
    -d \
    -p 9000:8080 ${DOCKER_IMAGE}
