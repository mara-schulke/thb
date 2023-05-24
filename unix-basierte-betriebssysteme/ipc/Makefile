.PHONY: build

build:
	rm -rf dist
	mkdir dist
	gcc -o dist/sum req.c sum.c -lrt
	gcc -o dist/sum_worker req.c worker.c -lrt

example:
	./dist/sum 1000000 50 5 &
