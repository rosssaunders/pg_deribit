docker build . -t pg_deribit
docker stop pg_deribit
docker rm -f pg_deribit
docker run -d --name pg_deribit -p 5433:5432 pg_deribit