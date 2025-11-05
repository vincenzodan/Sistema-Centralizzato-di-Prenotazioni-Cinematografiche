-- Esegui come utente "utente"

GRANT SELECT, INSERT, DELETE ON PROIEZIONI TO backup1;
GRANT SELECT, INSERT, DELETE ON POSTO TO backup1;
GRANT SELECT, INSERT, DELETE ON PRENOTAZIONI TO backup1;

---------------------------------------------------------
-- LOG DI SISTEMA
---------------------------------------------------------
CREATE TABLE Log (
    Messaggio VARCHAR2(200),
    DataLog   DATE DEFAULT SYSDATE,
    OraLog    TIMESTAMP DEFAULT SYSTIMESTAMP
);

---------------------------------------------------------
-- TABELLE ANAGRAFICHE
---------------------------------------------------------
CREATE TABLE UTENTE (
    Username  VARCHAR2(20) PRIMARY KEY,
    Password  VARCHAR2(20) NOT NULL,
    Nome      VARCHAR2(30) NOT NULL,
    Cognome   VARCHAR2(30) NOT NULL,
    Email     VARCHAR2(50) UNIQUE
);

CREATE TABLE CINEMA (
    IDCinema  VARCHAR2(10) PRIMARY KEY,
    Nome      VARCHAR2(50) NOT NULL,
    Indirizzo VARCHAR2(100) NOT NULL,
    Citta     VARCHAR2(30) NOT NULL,
    Cantone   VARCHAR2(30),
    Telefono  VARCHAR2(15),
    Num_Sale  NUMBER,
    Nazione   VARCHAR2(30)
);

CREATE TABLE SALE (
    Numero      VARCHAR2(10),
    CodCinema   VARCHAR2(10) NOT NULL,
    Capienza    NUMBER NOT NULL,
    Superficie  NUMBER,
    PRIMARY KEY (Numero, CodCinema),
    FOREIGN KEY (CodCinema) REFERENCES CINEMA(IDCinema)
);

CREATE TABLE GENERE (
    IDGenere VARCHAR2(10) PRIMARY KEY,
    Genere   VARCHAR2(30) UNIQUE NOT NULL
);

CREATE TABLE PAESE (
    IDPaese    VARCHAR2(10) PRIMARY KEY,
    NomePaese  VARCHAR2(30) UNIQUE NOT NULL
);

CREATE TABLE REGISTA (
    IDRegista  VARCHAR2(10) PRIMARY KEY,
    Nome       VARCHAR2(30) NOT NULL,
    Cognome    VARCHAR2(30) NOT NULL
);

CREATE TABLE ATTORI (
    IDAttore     VARCHAR2(10) PRIMARY KEY,
    Nome         VARCHAR2(30) NOT NULL,
    Cognome      VARCHAR2(30) NOT NULL,
    DDN          DATE,
    Nazionalita  VARCHAR2(30)
);

---------------------------------------------------------
-- TABELLE OPERATIVE
---------------------------------------------------------
CREATE TABLE FILM (
    IDFilm        VARCHAR2(10) PRIMARY KEY,
    Titolo        VARCHAR2(100) NOT NULL,
    Recensione    VARCHAR2(400),
    Anno          NUMBER,
    Durata        NUMBER,
    Data_Uscita   DATE,
    Distributore  VARCHAR2(50),
    CodGenere     VARCHAR2(10),
    CodPaese      VARCHAR2(10),
    CodRegista    VARCHAR2(10),
    FOREIGN KEY (CodGenere) REFERENCES GENERE(IDGenere),
    FOREIGN KEY (CodPaese) REFERENCES PAESE(IDPaese),
    FOREIGN KEY (CodRegista) REFERENCES REGISTA(IDRegista)
);

CREATE TABLE RECITA (
    IDRecita   VARCHAR2(10) PRIMARY KEY,
    Ruolo      VARCHAR2(30),
    CodFilm    VARCHAR2(10),
    CodAttore  VARCHAR2(10),
    FOREIGN KEY (CodFilm) REFERENCES FILM(IDFilm),
    FOREIGN KEY (CodAttore) REFERENCES ATTORI(IDAttore)
);

CREATE TABLE PROIEZIONI (
    IDProiezione  VARCHAR2(10) PRIMARY KEY,
    CodSala       VARCHAR2(10) NOT NULL,
    CodCinema     VARCHAR2(10) NOT NULL,
    CodFilm       VARCHAR2(10) NOT NULL,
    Giorno        DATE NOT NULL,
    Ora           TIMESTAMP NOT NULL,
    Prezzo        NUMBER(6,2),
    Posti_Disp    NUMBER,
    FOREIGN KEY (CodSala, CodCinema) REFERENCES SALE(Numero, CodCinema),
    FOREIGN KEY (CodFilm) REFERENCES FILM(IDFilm)
);

CREATE TABLE PRENOTAZIONI (
    IDPren          VARCHAR2(10) PRIMARY KEY,
    DataPren        DATE DEFAULT SYSDATE,
    OraPren         TIMESTAMP DEFAULT SYSTIMESTAMP,
    UsernameUtente  VARCHAR2(20),
    FOREIGN KEY (UsernameUtente) REFERENCES UTENTE(Username)
);

CREATE TABLE POSTO (
    Numero          NUMBER,
    CodProiezione   VARCHAR2(10),
    CodPren         VARCHAR2(10),
    PRIMARY KEY (Numero, CodProiezione),
    FOREIGN KEY (CodProiezione) REFERENCES PROIEZIONI(IDProiezione),
    FOREIGN KEY (CodPren) REFERENCES PRENOTAZIONI(IDPren)
);

---------------------------------------------------------
-- INDICI
---------------------------------------------------------
CREATE INDEX IDX_Film_Genere ON FILM(CodGenere);
CREATE INDEX IDX_Proiezioni_Film ON PROIEZIONI(CodFilm);
CREATE INDEX IDX_Posto_Pren ON POSTO(CodPren);

---------------------------------------------------------
-- TRIGGER
---------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_posti_disponibili
AFTER INSERT ON POSTO
FOR EACH ROW
BEGIN
   UPDATE PROIEZIONI
   SET Posti_Disp = Posti_Disp - 1
   WHERE IDProiezione = :NEW.CodProiezione;
END;
/

---------------------------------------------------------
-- STORED PROCEDURE
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE InsertUtente (
   p_Username IN UTENTE.Username%TYPE,
   p_Password IN UTENTE.Password%TYPE,
   p_Nome     IN UTENTE.Nome%TYPE,
   p_Cognome  IN UTENTE.Cognome%TYPE,
   p_Email    IN UTENTE.Email%TYPE
)
AS
   v_count INTEGER;
BEGIN
   SELECT COUNT(*) INTO v_count FROM UTENTE WHERE Username = p_Username;
   IF v_count > 0 THEN
      INSERT INTO Log (Messaggio)
      VALUES ('Tentativo di registrazione con username già esistente: ' || p_Username);
   ELSE
      INSERT INTO UTENTE (Username, Password, Nome, Cognome, Email)
      VALUES (p_Username, p_Password, p_Nome, p_Cognome, p_Email);
      COMMIT;
   END IF;
END;
/

---------------------------------------------------------
-- DATI DI TEST
---------------------------------------------------------
INSERT INTO GENERE VALUES ('G001','Azione');
INSERT INTO GENERE VALUES ('G002','Commedia');

INSERT INTO PAESE VALUES ('P001','USA');
INSERT INTO PAESE VALUES ('P002','Italia');

INSERT INTO REGISTA VALUES ('R001','Ridley','Scott');
INSERT INTO REGISTA VALUES ('R002','Alessandro','Siani');

INSERT INTO FILM VALUES ('F001','Il Gladiatore','Epico dramma storico','2000','155',
  TO_DATE('05/05/2000','DD/MM/YYYY'),'Universal Pictures','G001','P001','R001');
INSERT INTO FILM VALUES ('F002','Mister Felicità','Commedia brillante','2017','90',
  TO_DATE('01/01/2017','DD/MM/YYYY'),'01 Distribution','G002','P002','R002');

COMMIT;
