.PHONY: build

build:
	gcc -o sum req.c sum.c -lrt
	gcc -o sum_worker req.c worker.c -lrt

clean:
	rm sum sum_worker

example:
	sum 1000000 50 5 &
