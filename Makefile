PROJECT_DIR 							:=  $(shell pwd)
BASE_IMAGE_VERSION						=0.0.2
BASE_IMAGE_NAME							=registry.dafengstudio.cn/foldspace/foldspace-markdown-edit-server:${BASE_IMAGE_VERSION}
CONTAINER_NAME							=foldspace-saas-syncoya-worker
CURRENT_DATE							:= $(shell date)

help:
	@echo "USAGE:\t"
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF}' Makefile

.DEFAULT_GOAL=help
.PHONY=help

docker-build: ## build image
	docker build --progress=plain .  -t ${BASE_IMAGE_NAME}

docker-push: ## push image
	docker push ${BASE_IMAGE_NAME}

run: ## run local dev server
	docker-compose up --build
