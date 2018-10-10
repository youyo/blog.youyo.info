.DEFAULT_GOAL := help

## Create new post
new_post:
	echo 'create new file content/post/new-post.md'
	echo '---' >> content/post/new-post.md
	echo 'title: ""' >> content/post/new-post.md
	echo 'thumbnailImage: images/eye-catch/default.png' >> content/post/new-post.md
	echo 'thumbnailImagePosition: left' >> content/post/new-post.md
	echo 'metaAlignment: left' >> content/post/new-post.md
	echo "date: `date '+%Y-%m-%d'`" >> content/post/new-post.md
	echo 'categories:' >> content/post/new-post.md
	echo '- technology' >> content/post/new-post.md
	echo 'tags:' >> content/post/new-post.md
	echo '- ' >> content/post/new-post.md
	echo '---' >> content/post/new-post.md
	echo "\n\n" >> content/post/new-post.md
	echo '<!--more-->' >> content/post/new-post.md
	echo '<!-- toc -->' >> content/post/new-post.md

## Generate
generate:
	rm -rf public/
	hugo

## Deploy
deploy: generate
	gcloud --quiet app deploy

## Server
server:
	open http://localhost:1313/
	hugo -w server

## Show help
help:
	@make2help $(MAKEFILE_LIST)

.PHONY: help
.SILENT:
