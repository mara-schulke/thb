.PHONY: build install

build:
	gcc -o sum req.c sum.c -lrt
	gcc -o sum_worker req.c worker.c -lrt

clean:
	-rm sum sum_worker

install:
	mv sum sum_worker /usr/bin

example:
	sum 10000 50 5
