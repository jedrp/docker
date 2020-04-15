docker-compose -f elk/docker-compose.yml up -d
docker-compose -f mongo/docker-compose.yml up -d
docker-compose -f rabbitmq/docker-compose.yml up -d