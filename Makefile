.DEFAULT_GOAL := help

## Generate
generate:
	rm -rf public/
	hugo

## Deploy
deploy: generate
	gcloud --quiet app deploy --project=${PROJECT_ID}

## Show help
help:
	@make2help $(MAKEFILE_LIST)

.PHONY: help
.SILENT:
