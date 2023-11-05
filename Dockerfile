FROM ghcr.io/omnigres/omnigres-slim:latest

COPY deribit/. /usr/src/extension
WORKDIR /usr/src/extension
RUN Makefile
