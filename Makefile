.EXPORT_ALL_VARIABLES:

export CONTAINER_NAME=vocabulary-cli-game

.PHONY: build
build:
	docker build -t ${CONTAINER_NAME} .

.PHONY: run
run:
	docker run --rm -ti -v ${CURDIR}/.cache:/app/.cache ${CONTAINER_NAME} Rscript main.R ${wordtype}
