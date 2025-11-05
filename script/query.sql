---------------------------------------------------------
-- ESEMPI DI QUERY
---------------------------------------------------------

--Film prodotti in Italia
SELECT F.Titolo
FROM FILM F
JOIN PAESE P ON F.CodPaese = P.IDPaese
WHERE P.NomePaese = 'Italia';

--Titoli e generi dei film usciti dopo il 2001
SELECT F.Titolo, G.Genere
FROM FILM F
JOIN GENERE G ON F.CodGenere = G.IDGenere
WHERE F.Data_Uscita > TO_DATE('01/01/2001','DD/MM/YYYY');

--Film diretti da Ridley Scott
SELECT F.Titolo
FROM FILM F
JOIN REGISTA R ON F.CodRegista = R.IDRegista
WHERE R.Nome = 'Ridley' AND R.Cognome = 'Scott';

--Conteggio dei film per nazione
SELECT P.NomePaese, COUNT(F.IDFilm) AS NumeroFilm
FROM PAESE P
JOIN FILM F ON F.CodPaese = P.IDPaese
GROUP BY P.NomePaese;

--Film senza recensione
SELECT F.Titolo, G.Genere
FROM FILM F
JOIN GENERE G ON F.CodGenere = G.IDGenere
WHERE F.Recensione IS NULL;