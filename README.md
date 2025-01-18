# Inception

Un progetto Docker che implementa un'infrastruttura LEMP (Linux, Nginx, MariaDB, PHP) per ospitare un sito WordPress con SSL.

## 🏗️ Architettura

Il progetto è composto da tre container Docker principali:

1. **NGINX**: Server web con supporto SSL
2. **WordPress + PHP-FPM**: Application server
3. **MariaDB**: Database server

Tutti i container sono basati su Debian Bullseye e comunicano attraverso una rete Docker dedicata.

## 🔧 Componenti Principali

### NGINX
- Configurato per gestire HTTPS sulla porta 443
- Certificato SSL auto-firmato
- Supporto solo per TLSv1.2 e TLSv1.3
- Reverse proxy per WordPress

### WordPress
- Installazione automatizzata via WP-CLI
- PHP 8.2 con FPM
- Configurazione personalizzata per sicurezza e performance
- Volume persistente per i file

### MariaDB
- Database dedicato per WordPress
- Configurazione sicura e ottimizzata
- Volume persistente per i dati
- Accesso limitato alla rete interna Docker

## 🚀 Comandi Make

- `make all`: Setup iniziale e build dei container
- `make build`: Costruisce i container
- `make up`: Avvia i container
- `make down`: Ferma i container
- `make clean`: Pulisce container e volumi
- `make fclean`: Pulizia completa e ricostruzione
- `make check`: Verifica lo stato dei servizi
- `make shell-*`: Accede alla shell dei container (nginx/wordpress/mariadb)

## 🔒 Sicurezza

- Comunicazione HTTPS con certificato SSL
- Nessuna porta esposta tranne 443
- Variabili d'ambiente per credenziali sensibili

## 💾 Persistenza

I dati sono persistenti attraverso due volumi Docker:
- `/data/wordpress_files`: File di WordPress
- `/data/database`: Database MariaDB

## 📝 File di Configurazione

### docker-compose.yml
- Definisce tre servizi principali: nginx, wordpress e mariadb
- Gestisce le dipendenze tra container
- Configura le variabili d'ambiente
- Configura i volumi persistenti per database e file WordPress
- Gestisce la rete interna 'inception-network'
- Mappa la porta 443 per HTTPS
- Carica le variabili d'ambiente dal file .env

### Nginx
#### nginx.conf
- Configurazione globale del server nginx
- Impostazioni worker e eventi
- Configurazione dei log
- Ottimizzazioni delle performance

#### server.conf
- Configurazione del virtual host HTTPS
- Setup SSL con TLSv1.2/1.3
- Configurazione proxy pass verso PHP-FPM
- Gestione delle richieste WordPress

### WordPress
#### wp-config.php
- Configurazione del database WordPress
- Impostazioni di sicurezza
- Configurazione SSL
- Variabili d'ambiente per credenziali

#### www.conf
- Configurazione PHP-FPM
- Pool di processi PHP
- Socket di comunicazione con Nginx
- Gestione permessi e utenti

### MariaDB
#### 50-server.cnf
- Configurazione del server MariaDB
- Impostazioni di rete e sicurezza
- Ottimizzazioni delle performance
- Configurazione caratteri e collation

### Script
#### setup.sh (WordPress)
- Download e installazione WordPress
- Configurazione WP-CLI
- Creazione utente amministratore
- Setup temi e plugin

#### setup.sh (MariaDB)
- Inizializzazione database
- Creazione utente e database WordPress
- Configurazione permessi
- Importazione dump iniziale se presente

#### initial_setup.sh
- Creazione struttura directory
- Setup permessi corretti
- Preparazione ambiente host

## 🐳 Dockerfile

### Nginx (Dockerfile)
- Base image: debian:bullseye
- Installazione nginx e dipendenze SSL
- Generazione certificati SSL auto-firmati
- Copia delle configurazioni (nginx.conf, server.conf)
- Creazione directory per i file WordPress
- Esposizione porta 443
- Avvio nginx in modalità foreground

### WordPress (Dockerfile)
- Base image: debian:bullseye
- Installazione PHP 8.2-FPM e estensioni necessarie
- Setup directory WordPress e permessi
- Configurazione PHP-FPM (www.conf)
- Copia wp-config.php e script di setup
- Installazione WP-CLI
- Esposizione porta 9000 per PHP-FPM
- Esecuzione setup.sh all'avvio

### MariaDB (Dockerfile)
- Base image: debian:bullseye
- Installazione MariaDB-server
- Setup directory e permessi per MySQL
- Copia configurazione (50-server.cnf)
- Copia script di inizializzazione
- Esposizione porta 3306
- Esecuzione setup.sh all'avvio

## 🔍 Monitoraggio

- Log centralizzati per ogni servizio
- Script di controllo servizi (`check_services.sh`)
- Restart automatico in caso di fallimento

## ⚠️ Requisiti

- Docker e Docker Compose
- Make
- Almeno 1GB di spazio disco
- Porte 443 disponibili

## 🛠️ Setup Iniziale

1. Configurare il file `.env` con le variabili necessarie
2. Aggiungere `marboccu.42.fr` al file `/etc/hosts`
3. Eseguire `make all`
4. Accedere a `https://marboccu.42.fr`
