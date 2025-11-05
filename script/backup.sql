-- Esegui come utente "backup1"
---------------------------------------------------------
-- TABELLE DI BACKUP
---------------------------------------------------------
CREATE TABLE Backup_Proiezioni AS SELECT * FROM UTENTE.PROIEZIONI WHERE 1=0;
CREATE TABLE Backup_Posto      AS SELECT * FROM UTENTE.POSTO WHERE 1=0;
CREATE TABLE Backup_Pren       AS SELECT * FROM UTENTE.PRENOTAZIONI WHERE 1=0;

---------------------------------------------------------
-- STORED PROCEDURE: BACKUP AUTOMATICO
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE BACKUP_PROIEZIONI_STORICHE AS
BEGIN
   -- Copia proiezioni vecchie
   INSERT INTO BACKUP_PROIEZIONI
   SELECT * FROM UTENTE.PROIEZIONI
   WHERE GIORNO < SYSDATE - 30;

   -- Copia i posti associati alle proiezioni vecchie
   INSERT INTO BACKUP_POSTO
   SELECT P.*
   FROM UTENTE.POSTO P
   WHERE P.CODPROIEZIONE IN (
      SELECT IDPROIEZIONE
      FROM UTENTE.PROIEZIONI
      WHERE GIORNO < SYSDATE - 30
   );

   -- Copia le prenotazioni collegate ai posti
   INSERT INTO BACKUP_PREN
   SELECT PR.*
   FROM UTENTE.PRENOTAZIONI PR
   WHERE PR.IDPREN IN (
      SELECT CODPREN
      FROM UTENTE.POSTO
      WHERE CODPROIEZIONE IN (
         SELECT IDPROIEZIONE
         FROM UTENTE.PROIEZIONI
         WHERE GIORNO < SYSDATE - 30
      )
   );

   -- Cancella i record vecchi dallo schema UTENTE
   DELETE FROM UTENTE.POSTO WHERE CODPROIEZIONE IN (
      SELECT IDPROIEZIONE
      FROM UTENTE.PROIEZIONI
      WHERE GIORNO < SYSDATE - 30
   );

   DELETE FROM UTENTE.PRENOTAZIONI WHERE IDPREN IN (
      SELECT CODPREN
      FROM UTENTE.POSTO
      WHERE CODPROIEZIONE IN (
         SELECT IDPROIEZIONE
         FROM UTENTE.PROIEZIONI
         WHERE GIORNO < SYSDATE - 30
      )
   );

   DELETE FROM UTENTE.PROIEZIONI WHERE GIORNO < SYSDATE - 30;

   COMMIT;
END;
/
