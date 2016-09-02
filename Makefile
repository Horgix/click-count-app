all:: build run

build::
	docker run -it --rm -v ${PWD}:/usr/src/click-count -w /usr/src/click-count maven mvn clean package
	docker run --rm -v ${PWD}:/var/output busybox chown `id -u`:`id -g` /var/output/ -R
	docker build -t clickcount .

run::
	docker run --rm --name clickcount -p 80:8080 clickcount
