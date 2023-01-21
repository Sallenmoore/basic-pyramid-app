
all: test clean run

APP_NAME?="pyramidapp"
CONTAINERS=$(sudo docker ps -a -q)
PORT?=5000

build: clean
	docker compose --no-cache build $(APP_NAME)

run: 
	docker-compose up --build -d
	docker logs -f --since=15m -t $(APP_NAME)

start: clean run
	xdg-open 'http://localhost:$(PORT)'
###### CLEANING #######

clean:
	sudo docker ps -a
	-docker-compose down --remove-orphans
	-sudo docker kill $(CONTAINERS)

deepclean: clean
	-sudo docker container prune -f
	-sudo docker image prune -f
	-sudo docker system prune -a -f --volumes

###### TESTING #######

#OPTIONS
TEST_FUNC?="test_"

test: clean run
	echo "Running tests"
	-docker exec -it $(APP_NAME) python -m pytest -v -s tests/$(TEST_FUNC)*.py