deploy:
	rm -rf public/
	hugo
	sed -i "" 's|//blog.youyo.info|https://blog.youyo.info|g' public/sitemap.xml
	aws s3 sync --storage-class REDUCED_REDUNDANCY --delete public/ s3://blog.youyo.info/
	curl -X POST -H "Fastly-Key: ${FASTLY_APIKEY}" https://api.fastly.com/service/${FASTLY_SERVICE_ID}/purge_all
	rm -rf public/
