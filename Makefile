MARATHON_ENDPOINT=${MARATHON_URL}/v2/apps/click-count-${ENVIRONMENT}
# TODO : set BUILD_DIR if undefined

all:: build run

build::
	# Build .war
	docker run --rm -v ${BUILD_DIR}:/usr/src/click-count -w /usr/src/click-count ${MAVEN_OPTS_DOCKER} maven mvn clean package
	# Build Docker image
	docker build -t horgix/click-count:${CI_BUILD_REF} ${BUILD_DIR}

staging production::
	cp marathon_app.json marathon_app_${ENVIRONMENT}.json
	sed -i 's/__ENV__/${ENVIRONMENT}/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/${ENDPOINT}/' marathon_app_${ENVIRONMENT}.json
	curl -L -X PUT "${MARATHON_ENDPOINT}" -H "Content-type: application/json" -u "${MARATHON_USERNAME}:${MARATHON_PASSWORD}" -d @marathon_app_${ENVIRONMENT}.json 
