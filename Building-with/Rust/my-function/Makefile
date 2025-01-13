.PHONY: build

build:
	@cargo lambda build --release --output-format zip

target/lambda/my-function/bootstrap.zip: build
