-- DDL SCRIPT STARTS HERE

use SKK_BLÅ;

DROP TABLE IF EXISTS Hund_Kull;
DROP TABLE IF EXISTS Kull;
DROP TABLE IF EXISTS Kennel;
DROP TABLE IF EXISTS Veterinär_Historik;
DROP TABLE IF EXISTS Tävlings_Historik;
DROP TABLE IF EXISTS Saknad_Historik;
DROP TABLE IF EXISTS Hund;
DROP TABLE IF EXISTS Ras;
DROP TABLE IF EXISTS Roll_Person;
DROP TABLE IF EXISTS Roll;
DROP TABLE IF EXISTS Person;


CREATE TABLE Person (
    Person_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Personnummer VARCHAR(13) UNIQUE NOT NULL,
    Namn VARCHAR(50) NOT NULL
);

CREATE TABLE Roll (
    Roll_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Roll_namn VARCHAR(50) NOT NULL
);

CREATE TABLE Roll_Person (
    Roll_Person_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Person_ID int FOREIGN KEY REFERENCES Person(Person_ID),
    Roll_ID int FOREIGN KEY REFERENCES Roll(Roll_ID)
);

CREATE TABLE Ras (
    Ras_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    namn VARCHAR(50)
);

CREATE TABLE Hund (
    Hund_ID int PRIMARY KEY identity(1,1) NOT NULL,
    Regnummer VARCHAR(20) UNIQUE NOT NULL,
    Ägare int FOREIGN KEY REFERENCES Person(Person_ID) NOT NULL,
    Ras int FOREIGN KEY REFERENCES Ras(Ras_ID),
    Namn VARCHAR(50) NOT NULL,
    Kön CHAR CHECK(Kön = 'T' OR Kön = 'H') NOT NULL,
    Tat_ID VARCHAR(20),
    Chip_ID VARCHAR(20),
    Färg VARCHAR(20),
    Avliden_datum DATE
    );




CREATE TABLE Saknad_Historik(
    Historik_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Hund_ID int FOREIGN KEY REFERENCES Hund(Hund_ID) NOT NULL,
    Försvunnen DATE NOT NULL CHECK(Försvunnen < GETDATE()),
    Upphittad DATE CHECK(Upphittad < GETDATE())
);

CREATE TABLE Tävlings_Historik (
    Tävlings_Historik_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Hund_ID int FOREIGN KEY REFERENCES Hund(Hund_ID) NOT NULL,
    Dommare int FOREIGN KEY REFERENCES Person(Person_ID) NOT NULL,
    Datum DATE NOT NULL,
    Tävlings_Typ VARCHAR(50) NOT NULL,
    Placering int,
    Ort VARCHAR(50)
);

CREATE TABLE Veterinär_Historik (
    Veterinär_Historik_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Hund_ID int FOREIGN KEY REFERENCES Hund(Hund_ID) NOT NULL,
    Veterinär int FOREIGN KEY REFERENCES Person(Person_ID) NOT NULL,
    Datum DATE NOT NULL,
    Klinik VARCHAR(50) NOT NULL,
    Resultat VARCHAR(50) NOT NULL
);

CREATE TABLE Kennel (
    Kennel_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Namn VARCHAR(50) NOT NULL,
    Ort VARCHAR(50) NOT NULL
);

CREATE TABLE Kull (
    Kull_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Uppfödare int FOREIGN KEY REFERENCES Person(Person_ID),
    Kennel int FOREIGN KEY REFERENCES Kennel(Kennel_ID),
    Datum DATE NOT NULL,
);

CREATE TABLE Hund_Kull (
    Hund_Kull_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    Hund_ID int FOREIGN KEY REFERENCES Hund(Hund_ID) NOT NULL,
    Kull_ID int FOREIGN KEY REFERENCES Kull(Kull_ID) NOT NULL,
    Roll CHAR CHECK(Roll = 'M' OR Roll = 'F' OR Roll = 'B')
);


-- START INDEXING 

CREATE UNIQUE INDEX unique_tat_id_idx
ON Hund(Tat_ID)
where Tat_ID IS NOT NULL

CREATE UNIQUE INDEX unique_chip_id_idx
ON Hund(Chip_ID)
where Chip_ID IS NOT NULL

CREATE INDEX ras_namn_idx
ON Ras (namn);

CREATE INDEX roll_person_person_ID_idx
ON Roll_Person(Person_ID);

CREATE INDEX roll_person_roll_ID_idx
ON Roll_Person(roll_ID);

CREATE UNIQUE INDEX person_personnummer_idx
ON Person(personnummer);

CREATE INDEX Hund_namn_idx
ON Hund(namn);

CREATE INDEX Hund_chip_ID_idx
ON Hund(Chip_ID);

CREATE INDEX Saknad_Historik_hund_ID_idx
ON Saknad_Historik(Hund_ID);

CREATE INDEX Tävlings_Historik_hund_ID_idx
ON Tävlings_Historik(Hund_ID);

CREATE INDEX Tävlings_Historik_dommare_idx
ON Tävlings_Historik(Dommare);

CREATE INDEX Tävlings_Historik_ort_idx
ON Tävlings_Historik(Ort);

CREATE INDEX Veterinär_Historik_hund_ID_idx
ON Veterinär_Historik(Hund_ID);

CREATE INDEX Veterinär_Historik_veterinär_idx
ON Veterinär_Historik(Veterinär);

CREATE INDEX Veterinär_Historik_klinik_idx
ON Veterinär_Historik(Klinik);

CREATE INDEX Kennel_ort_idx
ON Kennel(Ort);

CREATE INDEX Kull_kennel_idx
ON Kull(Kennel);

CREATE INDEX Kull_uppfödare_idx
ON Kull(Uppfödare);

CREATE INDEX Hund_Kull_hund_ID_idx
ON Hund_Kull(Hund_ID);

CREATE INDEX Hund_Kull_kull_ID_idx
ON Hund_Kull(Kull_ID);

-- DDL END
