volume:
	docker volume create thb

image:
	docker buildx build . --tag thb

shell:
	docker run -it --rm --mount source=thb,target=/root --name thb thb
