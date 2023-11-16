#!/bin/bash

mkdir /var/lib/postgresql/certs
cd /var/lib/postgresql/certs

openssl req -new -text -passout pass:abcd -subj /CN=localhost -out server.req -keyout privkey.pem
openssl rsa -in privkey.pem -passin pass:abcd -out server.key
openssl req -x509 -in server.req -text -key server.key -out server.crt
chmod 600 server.key
test $(uname -s) == Linux && chown 999 server.key

cd

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER SYSTEM SET ssl_cert_file TO '/var/lib/postgresql/certs/server.crt';
    ALTER SYSTEM SET ssl_key_file TO '/var/lib/postgresql/certs/server.key';
    ALTER SYSTEM SET ssl TO 'ON';
EOSQL

sed '$ d' /var/lib/postgresql/data/pgdata/pg_hba.conf
#echo 'hostssl	all	    all		10.129.0.0/24		cert' >> /var/lib/postgresql/data/pgdata/pg_hba.conf