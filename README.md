# inception

```
docker compose down
docker compose up --build
```

1. Setup iniziale nginx --> creazione del servizio nel dockercompose e creazione del Dockerfile base per ora che installa solo nginx e espone la 443
2. Scrivere il file openssl.cnf e poi mkdir -p ssl e poi ` penssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/nginx.key -out ssl/nginx.crt -config openssl.cnf` per generare certificato e chiave + aggiungere nel file /etc/hosts il dominio https://login.42.fr.
3. Creare nginx.conf e copiarlo insieme alle chiavi nel container da Dockerfile (inclusa la parte per il supporto a TLS 1.2 e 1.3 only)
4. curl -k https://localhost or https://login.42.fr

1. Per wordpress ho configurato le impostazioni di base sul compose e nel dockerfile ho installato la giusta versione di php8.1 e i servizi php-curl, php-mysql e sopratutto php-fpm. Infine ho installato wordpress con il secondo comando RUN.
