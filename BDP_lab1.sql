-- zad.1
CREATE DATABASE firma;

-- zad.2
create schema ksiegowosc;

-- zad.3
CREATE TABLE ksiegowosc.pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR( 50 ) NOT NULL,
    nazwisko VARCHAR( 50 ) NOT NULL,
    adres VARCHAR( 100 ),
    telefon VARCHAR( 12 ),
    COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowująca informacje o pracownikach'
);

CREATE TABLE ksiegowosc.godziny (
    id_godziny SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    liczba_godzin INT,
    id_pracownika INT REFERENCES ksiegowosc.pracownicy( id_pracownika ),
    COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowująca informacje o godzinach'
);

CREATE TABLE ksiegowosc.pensja (
    id_pensji SERIAL PRIMARY KEY,
    stanowisko VARCHAR( 50 ) NOT NULL,
    kwota DECIMAL( 10, 2 ),
    COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowująca informacje o pensji'
);

CREATE TABLE ksiegowosc.premia (
    id_premii SERIAL PRIMARY KEY,
    rodzaj VARCHAR( 50 ),
    kwota DECIMAL( 10, 2 ),
    COMMENT ON TABLE ksiegowosc.premia IS 'Tabela przechowująca informacje o premiach'
);

CREATE TABLE ksiegowosc.wynagrodzenie (
    id_wynagrodzenia SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    id_pracownika INT REFERENCES ksiegowosc.pracownicy( id_pracownika ),
    id_godziny INT REFERENCES ksiegowosc.godziny( id_godziny ),
    id_pensji INT REFERENCES ksiegowosc.pensja( id_pensji ),
    id_premii INT REFERENCES ksiegowosc.premia( id_premii ),
    COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowująca informacje o wynagrodzeniu pracownika'
);

-- zad.5
INSERT INTO ksiegowosc.pracownicy ( imie, nazwisko, adres, telefon ) VALUES
('Jan', 'Kowalski', 'Warszawa, ul. Wesoła 1', '123456789'),
('Anna', 'Bęc', 'Kraków, ul. Zielona 2', '987654321'),
('Piotr', 'Nowak', 'Gdańsk, ul. Leśna 3', '234567891'),
('Alina', 'Kaczmarek', 'Poznań, ul. Szeroka 4', '876543219'),
('Tomasz', 'Kilo', 'Wrocław, ul. Kiełbasy 5', '345678912'),
('Maria', 'Budyń', 'Łódź, ul. Wspólna 6', '765432198'),
('Jakub', 'Lizak', 'Lublin, ul. Nowa 7', '456789123'),
('Magdalena', 'Wesołowska', 'Szczecin, ul. Główna 8', '654321987'),
('Paweł', 'Podlaski', 'Rzeszów, ul. Długa 9', '567891234'),
('Karolina', 'Kowal', 'Białystok, ul. Cicha 10', '432198765');

INSERT INTO ksiegowosc.godziny ( data, liczba_godzin, id_pracownika ) VALUES
('2024-10-21', 160, 1),
('2024-10-21', 180, 2),
('2024-10-21', 170, 3),
('2024-10-21', 190, 4),
('2024-10-21', 170, 5),
('2024-10-21', 160, 6),
('2024-10-21', 140, 7),
('2024-10-21', 170, 8),
('2024-10-21', 180, 9),
('2024-10-21', 160, 10);

INSERT INTO ksiegowosc.pensja ( stanowisko, kwota ) VALUES
('Kierownik', 6000.00),
('Zastępca', 3000.00),
('Asystent', 2000.00),
('Menedżer', 2500.00),
('Student', 2500.00),
('Kierowca', 2700.00),
('Developer', 2600.00),
('Kucharz', 2800.00),
('Sprzątaczka', 2300.00),
('Magazynier', 1800.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Premia roczna', 1000.00),
('Premia miesięczna', 500.00),
('Premia tygodniowa', 200.00),
('Premia dzienna', 100.00),
('Premia dodatkowa', 600.00),
('Premia świąteczna', 800.00),
('Premia bożonarodzeniowa', 900.00),
('Premia bezokazyjna', 300.00),
('Premia urodzinowa', 400.00),
('Brak', 0.00);

INSERT INTO ksiegowosc.wynagrodzenie ( data, id_pracownika, id_godziny, id_pensji, id_premii ) VALUES
('2024-10-31', 1, 1, 1, 1),
('2024-10-31', 2, 2, 2, 2),
('2024-10-31', 3, 3, 3, 3),
('2024-10-31', 4, 4, 4, 2),
('2024-10-31', 5, 5, 5, 10),
('2024-10-31', 6, 6, 1, 1),
('2024-10-31', 7, 7, 2, 3),
('2024-10-31', 8, 8, 3, 2),
('2024-10-31', 9, 9, 4, 10),
('2024-10-31', 10, 10, 5, 3);


-- zad.5
-- a)
SELECT id_pracownika, nazwisko 
FROM ksiegowosc.pracownicy;

-- b)
SELECT p.id_pracownika FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pn ON w.id_pensji = pn.id_pensji
WHERE pn.kwota > 1000;


-- c)
SELECT p.id_pracownika FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pn ON w.id_pensji = pn.id_pensji
WHERE pn.kwota > 1000
AND w.id_premii = 10;

-- d)
SELECT *
FROM ksiegowosc.pracownicy p
WHERE p.imie LIKE 'J%';

-- e)
SELECT *
FROM ksiegowosc.pracownicy p
WHERE p.imie LIKE 'N%'
AND p.nazwisko LIKE '%a';

-- f)
SELECT p.imie, p.nazwisko, ( g.liczba_godzin - 160 ) AS liczba_nadgodzin
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika
WHERE g.liczba_godzin > 160;

-- g)
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
JOIN ksiegowosc.pensja pn ON pn.id_pensji = w.id_pensji 
WHERE ( pn.kwota < 3000 AND pn.kwota > 1500 );

-- h)
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.godziny g ON w.id_godziny = g.id_godziny
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
WHERE g.liczba_godzin > 160 AND pr.id_premii = 10;

-- i)
SELECT p.imie, p.nazwisko, pn.kwota
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.pensja pn ON p.id_pracownika = pn.id_pensji
ORDER BY pn.kwota ASC;

-- j)
SELECT p.imie, p.nazwisko, pn.kwota, COALESCE( pr.kwota, 0 ) AS premia_kwota
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.pensja pn ON p.id_pracownika = pn.id_pensji
LEFT JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
ORDER BY pn.kwota DESC, premia_kwota DESC;

-- k)
SELECT pn.stanowisko, COUNT(*) AS liczba_pracownikow
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.pensja pn ON p.id_pracownika = pn.id_pensji
GROUP BY pn.stanowisko;

-- l)
SELECT AVG( pn.kwota ) AS srednia, MIN( pn.kwota ) AS minimalna, MAX( pn.kwota ) AS maksymalna
FROM ksiegowosc.pensja pn
WHERE pn.stanowisko = 'Kierownik';

-- m)
SELECT SUM( pn.kwota + pr.kwota ) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pn ON w.id_pensji = pn.id_pensji 
JOIN ksiegowosc.premia pr ON pr.id_premii = w.id_premii

-- n)
SELECT pn.stanowisko, SUM( pn.kwota + pr.kwota ) AS suma_wynagrodzen
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pn ON w.id_pensji = pn.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
GROUP BY pn.stanowisko;

-- o)
SELECT pn.stanowisko, COUNT( pr.id_premii ) AS liczba_premii
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pn ON w.id_pensji = pn.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
GROUP BY pn.stanowisko;

-- p)
DELETE FROM ksiegowosc.pracownicy
WHERE id_pracownika IN (
	SELECT p.id_pracownika
	FROM ksiegowosc.pracownicy p
	JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
	JOIN ksiegowosc.pensja pn ON pn.id_pensji = w.id_pensji
	WHERE pn.kwota < 2500
);


