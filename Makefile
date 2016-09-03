BUILD_DIR="/tmp/gitlab-build-${CI_BUILD_ID}"

all:: build run

build::
	mkdir -p ${BUILD_DIR}
	cp ${PWD} ${BUILD_DIR} -R
	docker run --rm -v ${BUILD_DIR}/click-count:/usr/src/click-count -w /usr/src/click-count maven mvn clean package
	docker build -t horgix/click-count:${CI_BUILD_REF} ${BUILD_DIR}/click-count

staging::
	cp marathon_app.json marathon_app_staging.json
	sed -i 's/__ENV__/integ/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/app.svc.deploy.coffee/' marathon_app_staging.json
	curl -L -X PUT "https://svc.deploy.coffee:8080/v2/apps" -H "Content-type: application/json" -u "horgix:verysecure" -d @marathon_app_staging.json 

production::
	cp marathon_app.json marathon_app_production.json
