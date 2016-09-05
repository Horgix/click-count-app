BUILD_DIR="/tmp/gitlab-build-${CI_BUILD_ID}"
MARATHON_ENDPOINT=${MARATHON_URL}/v2/apps/click-count-${ENVIRONMENT}

all:: build run

build::
	mkdir -p ${BUILD_DIR}
	cp ${PWD} ${BUILD_DIR} -R
	docker run --rm -v ${BUILD_DIR}/click-count:/usr/src/click-count -w /usr/src/click-count maven mvn clean package
	docker build -t horgix/click-count:${CI_BUILD_REF} ${BUILD_DIR}/click-count

staging production::
	cp marathon_app.json marathon_app_${ENVIRONMENT}.json
	sed -i 's/__ENV__/${ENVIRONMENT}/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/${ENDPOINT}/' marathon_app_${ENVIRONMENT}.json
	curl -L -X PUT "${MARATHON_ENDPOINT}" -H "Content-type: application/json" -u "${MARATHON_USERNAME}:${MARATHON_PASSWORD}" -d @marathon_app_${ENVIRONMENT}.json 
