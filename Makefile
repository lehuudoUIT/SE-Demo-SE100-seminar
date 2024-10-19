.PHONY: create-network
create-network:
	@echo Starting create network
	docker network create network01 && \
		docker network create network02

.PHONY: run-postgres
run-postgres:
	@echo Starting postgres container
	-docker run \
		--name postgresdb \
		-e POSTGRES_PASSWORD=foobarbaz \
		-v pgdata:/var/lib/postgresql/data \
		-p 5432:5432 \
		--network network01 \
		-d \
		postgres:15.1-alpine

.PHONY: build-node
build-node:
	@echo Starting build node image
	cd api-node && \
		docker build -t docker-backend-demo .

.PHONY: run-api-node
run-api-node:
	@echo Starting node api
	docker run -it -d --name node-backend --network network01 --network network02 --expose 3000 docker-backend-demo

.PHONY: build-react
build-react:
	@echo Starting build node image
	cd client-react && \
		docker build -t docker-frontend-demo .

.PHONY: run-client-react
run-client-react:
	@echo Starting node api
	docker run -it -d --name react-frontend --network network02 -p 5173:5173 docker-frontend-demo