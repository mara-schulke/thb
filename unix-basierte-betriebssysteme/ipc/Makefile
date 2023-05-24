.PHONY: build

build:
	rm -rf dist
	mkdir dist
	gcc -o dist/sum sum.c -lrt
	gcc -o dist/sum_worker worker.c -lrt

example:
	./dist/sum 1000000 50 25
