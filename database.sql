/* ===============================
   CREAZIONE DATABASE
   =============================== */
CREATE DATABASE Forniture;
USE Forniture;

/* ===============================
   CREAZIONE TABELLE
   =============================== */
CREATE TABLE Fornitori (
    fid VARCHAR(10) PRIMARY KEY,
    fnome VARCHAR(50),
    indirizzo VARCHAR(100)
);

CREATE TABLE Pezzi (
    pid VARCHAR(10) PRIMARY KEY,
    pnome VARCHAR(50),
    colore VARCHAR(20)
);

CREATE TABLE Catalogo (
    fid VARCHAR(10),
    pid VARCHAR(10),
    costo REAL,
    PRIMARY KEY (fid, pid),
    FOREIGN KEY (fid) REFERENCES Fornitori(fid),
    FOREIGN KEY (pid) REFERENCES Pezzi(pid)
);

/* ===============================
   INSERIMENTO DATI
   =============================== */
INSERT INTO Fornitori VALUES
('F1', 'Acme', 'Roma'),
('F2', 'Beta', 'Milano'),
('F3', 'Gamma', 'Torino');

INSERT INTO Pezzi VALUES
('P1', 'Vite', 'rosso'),
('P2', 'Bullone', 'blu'),
('P3', 'Dado', 'rosso');

INSERT INTO Catalogo VALUES
('F1', 'P1', 10),
('F1', 'P2', 15),
('F2', 'P1', 12),
('F2', 'P3', 8),
('F3', 'P1', 9),
('F3', 'P2', 14),
('F3', 'P3', 11);

/* ===============================
   QUERY
   =============================== */

-- 1. Trovare i pnome dei pezzi per cui esiste un qualche fornitore
SELECT DISTINCT p.pnome
FROM Pezzi p
JOIN Catalogo c ON p.pid = c.pid;

-- 2. Trovare gli fnome dei fornitori che forniscono ogni pezzo
SELECT f.fnome
FROM Fornitori f
WHERE NOT EXISTS (
    SELECT *
    FROM Pezzi p
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalogo c
        WHERE c.fid = f.fid
        AND c.pid = p.pid
    )
);

-- 3. Trovare gli fnome dei fornitori che forniscono tutti i pezzi rossi
SELECT f.fnome
FROM Fornitori f
WHERE NOT EXISTS (
    SELECT *
    FROM Pezzi p
    WHERE p.colore = 'rosso'
    AND NOT EXISTS (
        SELECT *
        FROM Catalogo c
        WHERE c.fid = f.fid
        AND c.pid = p.pid
    )
);

-- 4. Trovare i pnome dei pezzi forniti dalla Acme e da nessun altro
SELECT p.pnome
FROM Pezzi p
JOIN Catalogo c ON p.pid = c.pid
JOIN Fornitori f ON c.fid = f.fid
WHERE f.fnome = 'Acme'
AND p.pid NOT IN (
    SELECT c2.pid
    FROM Catalogo c2
    JOIN Fornitori f2 ON c2.fid = f2.fid
    WHERE f2.fnome <> 'Acme'
);

-- 5. Trovare i fid dei fornitori che ricaricano su alcuni pezzi
--    più del costo medio di quel pezzo
SELECT DISTINCT c.fid
FROM Catalogo c
WHERE c.costo > (
    SELECT AVG(c2.costo)
    FROM Catalogo c2
    WHERE c2.pid = c.pid
);

-- 6. Per ciascun pezzo, trovare gli fnome dei fornitori
--    che ricaricano di più su quel pezzo
SELECT p.pnome, f.fnome
FROM Pezzi p
JOIN Catalogo c ON p.pid = c.pid
JOIN Fornitori f ON c.fid = f.fid
WHERE c.costo = (
    SELECT MAX(c2.costo)
    FROM Catalogo c2
    WHERE c2.pid = p.pid
);
-- 7. Trovare i fid dei fornitori che forniscono SOLO pezzi rossi
SELECT DISTINCT f.fid
FROM Fornitori f
WHERE NOT EXISTS (
    SELECT *
    FROM Catalogo c
    JOIN Pezzi p ON c.pid = p.pid
    WHERE c.fid = f.fid
    AND p.colore <> 'rosso'
);

-- 8. Trovare i fid dei fornitori che forniscono
--    un pezzo rosso E un pezzo verde
SELECT f.fid
FROM Fornitori f
WHERE EXISTS (
    SELECT *
    FROM Catalogo c
    JOIN Pezzi p ON c.pid = p.pid
    WHERE c.fid = f.fid
    AND p.colore = 'rosso'
)
AND EXISTS (
    SELECT *
    FROM Catalogo c
    JOIN Pezzi p ON c.pid = p.pid
    WHERE c.fid = f.fid
    AND p.colore = 'verde'
);

-- 9. Trovare i fid dei fornitori che forniscono
--    un pezzo rosso O uno verde
SELECT DISTINCT f.fid
FROM Fornitori f
JOIN Catalogo c ON f.fid = c.fid
JOIN Pezzi p ON c.pid = p.pid
WHERE p.colore = 'rosso'
   OR p.colore = 'verde';

-- 10. Trovare i pid dei pezzi forniti da almeno due fornitori
SELECT pid
FROM Catalogo
GROUP BY pid
HAVING COUNT(DISTINCT fid) >= 2;