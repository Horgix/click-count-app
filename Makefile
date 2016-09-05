BUILD_DIR="/tmp/gitlab-build-${CI_BUILD_ID}"
MARATHON_ENDPOINT=${MARATHON_URL}/v2/apps/click-count?force=true

all:: build run

build::
	mkdir -p ${BUILD_DIR}
	cp ${PWD} ${BUILD_DIR} -R
	docker run --rm -v ${BUILD_DIR}/click-count:/usr/src/click-count -w /usr/src/click-count maven mvn clean package
	docker build -t horgix/click-count:${CI_BUILD_REF} ${BUILD_DIR}/click-count

staging::
	cp marathon_app.json marathon_app_staging.json
	sed -i 's/__ENV__/staging/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/${STAGING_ENDPOINT}/' marathon_app_staging.json
	curl -L -X PUT "${MARATHON_ENDPOINT}" -H "Content-type: application/json" -u "${MARATHON_USERNAME}:${MARATHON_PASSWORD}" -d @marathon_app_staging.json 

production::
	cp marathon_app.json marathon_app_production.json
	sed -i 's/__ENV__/production/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/${PRODUCTION_ENDPOINT}/' marathon_app_production.json
	curl -L -X PUT "${MARATHON_ENDPOINT}" -H "Content-type: application/json" -u "${MARATHON_USERNAME}:${MARATHON_PASSWORD}" -d @marathon_app_production.json 
