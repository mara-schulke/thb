.PHONY: build uninstall install

build:
	gcc -o sum req.c ipc.c sum.c -lrt
	gcc -o sum_worker req.c ipc.c worker.c -lrt

clean:
	-rm sum sum_worker

install:
	mv sum sum_worker /usr/bin

uninstall:
	-rm /usr/bin/sum /usr/bin/sum_worker

example:
	sum 100000 100 3
