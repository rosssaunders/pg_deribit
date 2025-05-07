make all

docker build . -t pg_deribit

# stop existing container called pg_deribit
docker stop pg_deribit

# remove any existing container called pg_deribit
docker rm -f pg_deribit

# launch the new one
docker run -d --name pg_deribit -p 5433:5432 pg_deribit
