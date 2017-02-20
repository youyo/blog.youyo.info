deploy:
	rm -rf public/
	hugo ; echo ok
	aws s3 sync --delete public/ s3://blog.youyo.info/
	curl -X POST -H "Fastly-Key: ${FASTLY_APIKEY}" https://api.fastly.com/service/${FASTLY_SERVICE_ID}/purge_all
	rm -rf public/
