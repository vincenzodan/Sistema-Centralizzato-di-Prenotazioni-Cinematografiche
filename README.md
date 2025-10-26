# 🎬 Sistema Centralizzato di Prenotazioni Cinematografiche
Questo progetto realizza un sistema informativo centralizzato per la gestione delle prenotazioni cinematografiche in Svizzera.  
Il progetto integra dati relativi a film, programmazioni, utenti e prenotazioni provenienti da diversi cinema e cantoni, garantendo consistenza e affidabilità grazie a procedure di backup, gestione dei ruoli e trigger automatici.

## 📘 Documentazione Tecnica
Consulta la [documentazione tecnica](./Documentazione.pdf) per dettagli sull’architettura, il modello relazionale e le procedure PL/SQL implementate.

---
## 🛠️ Tecnologie

<table>
  <tr>
    <td align="center">
      <a href="https://www.oracle.com/database/" target="_blank">
        <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/oracle/oracle-original.svg" width="50" height="50"/><br>
        Oracle Database
      </a>
    </td>
    <td align="center">
      <a href="https://www.sql.org/" target="_blank">
        <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/sqldeveloper/sqldeveloper-original.svg" width="50" height="50"/><br
        SQL Developer
      </a>
    </td>
  </tr>
</table>

## 📖 Istruzioni per l'Esecuzione

1. **Collegamento al database Oracle XE**  
   Aprire Oracle SQL Developer e connettersi al PDB `XEPDB1` con un utente con privilegi DBA (`SYSTEM`) per creare tablespace e utenti:
2. **Creazione tablespace e utenti** ([configurazione.sql](./configurazione.sql))
   - Tablespace principali: `TS_CINEMA` e `TS_BACKUP`
   - Utenti: utente (principale) e backup1 (backup)
3. **Esecuzione script utente** ([utente.sql](./utente.sql))
   - Creazione tabelle operative e anagrafiche
   - Definizione trigger e stored procedure (`InsertUtente`)
   - Assegnazione ruoli e privilegi
4. **Esecuzione script backup** ([backup.sql](./backup.sql))
   - Creazione tabelle di backup
   - Definizione procedura `BACKUP_PROIEZIONI_STORICHE`

## 🗂️ Struttura del Progetto

```
Sistema-Centralizzato-di-Prenotazioni-Cinematografiche/
│
├── scripts/
│   ├── configurazione.sql       # Script per creazione tablespace e utenti 
│   ├── utente.sql               # Script per creazione tabelle, trigger, procedure, ruoli e grants
│   ├── backup.sql               # Script per backup tabelle e procedure automatiche
│   ├── query.sql                # Script con esempi di query
│
├── Documentazione.pdf           # Documentazione completa del progetto
└─ README.md                     # Istruzioni per installazione e uso del progetto

```
---

## 👥 Contributors

- [@Vincenzo D'Angelo](https://github.com/vincenzodan)
