FROM ghcr.io/omnigres/omnigres-slim:latest

RUN wget -c http://api.pgxn.org/dist/pgtap/1.1.0/pgtap-1.1.0.zip
RUN unzip pgtap-*
RUN export PATH=$PATH:$PGBINDIR/bin && cd pgtap-1.1.0 && make && make install

#COPY deribit/. /usr/src/extension
#WORKDIR /usr/src/extension
#RUN Makefile
