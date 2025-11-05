---------------------------------------------------------
-- 0️⃣ Collegamento al PDB
---------------------------------------------------------
-- Eseguire come SYSTEM o un utente con privilegi DBA
ALTER SESSION SET CONTAINER = XEPDB1;

---------------------------------------------------------
-- 1 CREAZIONE TABLESPACE
---------------------------------------------------------
-- Tablespace principale per i dati del database
CREATE TABLESPACE ts_cinema
DATAFILE 'C:\APP\VINCE\PRODUCT\21C\ORADATA\XE\ts_cinema.dbf'
SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 12G;

-- Tablespace per backup
CREATE TABLESPACE ts_backup
DATAFILE 'C:\APP\VINCE\PRODUCT\21C\ORADATA\XE\ts_backup.dbf'
SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 12G;

---------------------------------------------------------
-- 2 CREAZIONE UTENTI LOCALI
---------------------------------------------------------
-- Utente principale per operare sul database
CREATE USER utente
IDENTIFIED BY 12345
DEFAULT TABLESPACE ts_cinema
TEMPORARY TABLESPACE TEMP;

-- Utente per operazioni di backup
CREATE USER backup1
IDENTIFIED BY 12345
DEFAULT TABLESPACE ts_backup
TEMPORARY TABLESPACE TEMP;

---------------------------------------------------------
-- 3️ ASSEGNAZIONE PRIVILEGI
---------------------------------------------------------
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO utente;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO backup1;

---------------------------------------------------------
-- 4 VERIFICA CREAZIONE
---------------------------------------------------------
-- Controllo tablespace
SELECT TABLESPACE_NAME, FILE_NAME, BYTES/1024/1024 AS SIZE_MB
FROM DBA_DATA_FILES
WHERE TABLESPACE_NAME IN ('TS_CINEMA', 'TS_BACKUP');

-- Controllo utenti
SELECT USERNAME, DEFAULT_TABLESPACE, ACCOUNT_STATUS
FROM DBA_USERS
WHERE USERNAME IN ('UTENTE', 'BACKUP1');

---------------------------------------------------------
-- RUOLI E PERMESSI
---------------------------------------------------------

-- Ruolo UTENTI: può lavorare con prenotazioni e posti
GRANT SELECT, INSERT, UPDATE ON UTENTE.PRENOTAZIONI TO utenti;
GRANT SELECT, INSERT ON UTENTE.POSTO TO utenti;

-- Ruolo REFERENTI: può gestire tutto il contenuto del cinema
GRANT SELECT, INSERT, UPDATE ON UTENTE.FILM TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.PROIEZIONI TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.GENERE TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.PAESE TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.ATTORI TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.REGISTA TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.SALE TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.CINEMA TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.POSTO TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.PRENOTAZIONI TO referenti;
GRANT SELECT, INSERT, UPDATE ON UTENTE.RECITA TO referenti;

-- Ruolo SITI_ESTERNI: solo lettura
GRANT SELECT ON UTENTE.FILM TO siti_esterni;
GRANT SELECT ON UTENTE.PROIEZIONI TO siti_esterni;
GRANT SELECT ON UTENTE.PAESE TO siti_esterni;
GRANT SELECT ON UTENTE.GENERE TO siti_esterni;
GRANT SELECT ON UTENTE.ATTORI TO siti_esterni;
GRANT SELECT ON UTENTE.REGISTA TO siti_esterni;
GRANT SELECT ON UTENTE.RECITA TO siti_esterni;

---------------------------------------------------------
-- Assegnazione dei ruoli all’utente principale
---------------------------------------------------------
GRANT utenti TO UTENTE;
GRANT referenti TO UTENTE;
GRANT siti_esterni TO UTENTE;