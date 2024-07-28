FROM --platform=linux/amd64 registry.access.redhat.com/ubi9/ubi

RUN dnf install -y zip unzip which sudo wget

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install

# Setup Lambda-like runtime
#
# ENV LAMBDA_RUNTIME_DIR /var/runtime
ENV LAMBDA_TASK_ROOT /var/task

# Lambda function always starts on this directory
WORKDIR ${LAMBDA_TASK_ROOT}

COPY bootstrap .
COPY function.sh .

CMD [ "./bootstrap" ]
