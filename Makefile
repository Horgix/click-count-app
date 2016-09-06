# The variables used in this file are defined by GitLab CI
#
MARATHON_ENDPOINT	= ${MARATHON_URL}/v2/apps/click-count-${ENVIRONMENT}

# Development placeholders
BUILD_DIR		?= ${PWD}
CI_BUILD_REF		?= dev
MAVEN_OPTS_DOCKER	?= -v ${HOME}/.m2:/root/.m2

all:: build

build::
	# Build .war
	docker run --rm -v ${BUILD_DIR}:/usr/src/click-count -w /usr/src/click-count ${MAVEN_OPTS_DOCKER} maven mvn clean package
	# Build Docker image
	docker build -t horgix/click-count:${CI_BUILD_REF} ${BUILD_DIR}

staging production::
	cp marathon_app.json marathon_app_${ENVIRONMENT}.json
	# Poor templating
	sed -i 's/__ENV__/${ENVIRONMENT}/;s/__VERSION__/${CI_BUILD_REF}/;s/__DOMAIN_NAME__/${ENDPOINT}/;s/__REDIS_HOST__/${REDIS_HOST}/' marathon_app_${ENVIRONMENT}.json
	curl -L -X PUT "${MARATHON_ENDPOINT}" -H "Content-type: application/json" -u "${MARATHON_USERNAME}:${MARATHON_PASSWORD}" -d @marathon_app_${ENVIRONMENT}.json 

.SILENT: dev

dev::
	echo "Removing existing instances..."
	-docker rm -f click-count-dev 2> /dev/null ; true
	-docker rm -f click-count-dev-db 2> /dev/null ; true
	echo "Spawning redis and click-count dev instances..."
	docker run -d --name click-count-dev-db redis:latest
	docker run -d --name click-count-dev -p 8080:8080 --link click-count-dev-db:redis -e REDIS_HOST=redis horgix/click-count:dev
	echo "Application ready on localhost:8080"
