BUILD_DIR="/tmp/gitlab-build-${CI_BUILD_ID}"

all:: build run

build::
	mkdir -p ${BUILD_DIR}
	cp ${PWD} ${BUILD_DIR} -R
	ls -lah ${BUILD_DIR}
	docker run --rm -v ${BUILD_DIR}/click-count:/usr/src/click-count -w /usr/src/click-count maven mvn clean package
	#docker run --rm -v ${PWD}:/var/output busybox chown `id -u`:`id -g` /var/output/ -R
	docker build -t clickcount ${BUILD_DIR}/click-count

run::
	docker run --rm --name clickcount -p 80:8080 clickcount
