all: build up ps
reset: down prune build up ps

ps:
	docker-compose ps
up:
	docker-compose up -d
build:
	docker-compose build
down:
	docker-compose down -v
prune:
	docker system prune -f

lhttpd:
	docker exec -it httpd-container bash
lnginx:
	docker exec -it nginx-container bash
