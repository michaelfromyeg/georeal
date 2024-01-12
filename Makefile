.PHONY: server build up logs down kill test prune

server:
	@echo "Running the server locally..."
	@python -m georeal.server

build:
	@echo "Building the server..."
	@docker build -t georeal-server .

up:
	@echo "Booting up the server..."
	@docker run -p 5000:5000 -d --name georeal-server-instance georeal-server

logs:
	@echo "Showing the server logs..."
	@docker logs --follow georeal-server-instance

down:
	@echo "Shutting down the server..."
	@docker stop georeal-server-instance
	@docker rm georeal-server-instance

kill:
	@echo "Killing the server..."
	@docker kill georeal-server-instance

test:
	@echo "Running the tests..."
	@python -m pytest

prune:
	@echo "Pruning the docker system..."
	@docker system prune -f
