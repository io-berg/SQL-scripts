-- DML SCRIPT STARTS HERE 

use SKK_BLÅ;

INSERT INTO Ras (namn)
SELECT Name FROM Gemensam.dbo.raser;

INSERT INTO Roll (Roll_namn) values
    ('Veterinär'),
    ('Uppfödare'),
    ('Ägare'),
    ('Domare');

INSERT INTO Person (Personnummer, Namn) VALUES 
    ('199001242222', 'Per Persson'),
    ('198002423333', 'Klas Klasson'),
    ('197003244444', 'Dom Domsson'),
    ('196004255555', 'Ägare Ägsson'),
    ('192004266666', 'Lindius Birgitta'),
    ('182004227777', 'Gustav Gustavson'),
    ('194502268888', 'Jason Jasonsson');

INSERT INTO Roll_Person (Person_ID, Roll_ID) VALUES 
    (1,3),
    (2,2),
    (2,3),
    (3,4),
    (3,3),
    (4,1),
    (4,3),
    (5,2),
    (6,3),
    (7,3);

INSERT INTO Hund (Regnummer, Ägare, Namn, Ras, Kön, Tat_ID, Chip_ID, Färg, Avliden_datum) VALUES 
    ('S37027/90', 1, 'Fantasia-Li', 231, 'T', null, '977200004100436', 'Vit', NULL),
    ('F35217/10',2, 'Lissmas Findus', 231, 'H', null, '977204104100436', 'Blå', NULL),
    ('B37022/21',3, 'Lissmas Fritz-Leo', 231, 'H', null, '977100704200636', 'Grå', NULL),
    ('S12345/80',4, 'Lissmas Freja-Li', 231, 'T', null, '977262014607436', 'Svart', NULL),
    ('S11111/80',6, 'Yvund Kevin', 231, 'H', null, '977212516607436', 'Grå', '2019-05-23'),
    ('S44213/80',7, 'Terrific Contessa', 231, 'T', null, '977164011601416', 'Svart', '2018-01-11');

INSERT INTO Saknad_Historik (Hund_ID, Försvunnen, Upphittad) VALUES (1, '2021-10-04', '2021-11-01');

INSERT INTO Tävlings_Historik (Hund_ID, Dommare, Datum, Tävlings_Typ, Placering, Ort) VALUES 
    (1, 3, '2020-10-10', 'Rally lydnad', 9, 'Ulricehamn'),
    (1, 3, '2020-10-11', 'Agility', 1, 'Borås');

INSERT INTO Veterinär_Historik (Hund_ID, Veterinär, Datum, Klinik, Resultat) VALUES 
    (1, 4, '2006-12-15', 'Blå stjärnans Djursjukhus Borås', 'HD grad A'),
    (2, 4, '2008-11-12', 'Blå stjärnans Djursjukhus Borås', 'patella, ua'),
    (1, 4, '2007-05-11', 'Blå stjärnans Djursjukhus Borås', 'HD grad B');


INSERT INTO Kennel (Namn, Ort) VALUES 
    ('LISSMAS', 'Skogås'),
    ('Honeyfarms', 'Grödinge');

INSERT INTO Kull (Uppfödare, Kennel, Datum) VALUES 
    (2, 1, '2005-06-08'),
    (5, 2, '2002-01-02');

INSERT INTO Hund_Kull (Hund_ID, Kull_ID, Roll) VALUES 
    (1, 1, 'B'),
    (2, 1, 'B'),
    (3, 1, 'B'),
    (4, 1, 'B'),
    (5, 1, 'F'),
    (6, 1, 'M');


-- DML END


