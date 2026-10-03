FROM public.ecr.aws/lambda/provided:al2023

# Copy custom runtime bootstrap
COPY bootstrap ${LAMBDA_RUNTIME_DIR}
# Copy function code
COPY function.sh ${LAMBDA_TASK_ROOT}

CMD [ "function.handler" ]
