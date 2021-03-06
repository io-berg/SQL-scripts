-- PROCEDURES START HERE

GO
CREATE OR ALTER PROCEDURE Statistics_Get
AS
BEGIN

    SELECT COUNT(Hund.Hund_ID) AS 'Antal Hundar', 
        (Select COUNT(Tävlings_Historik.Tävlings_Historik_ID) FROM Tävlings_Historik) 'Antal Tävlingsuppgifter', 
        (SELECT COUNT(Veterinär_Historik.Veterinär_Historik_ID) FROM Veterinär_Historik) 'Antal veterinäruppgifter' 
    FROM Hund;
	RETURN 

END
GO

CREATE OR ALTER PROCEDURE Gender_GetAll
    (@Kön Char)
AS
BEGIN
    SELECT Regnummer, hund.Namn, Tat_ID, Chip_ID, Kön, ras.namn as Ras FROM Hund
    INNER JOIN RAS ON Ras.Ras_ID = Hund.Ras
    WHERE Hund.Kön = @Kön
	-- Implementera
	-- hundar.skk.se/hunddata/Hund_sok.aspx
	RETURN 

END
GO

CREATE OR ALTER PROCEDURE Breed_GetAll
    (@Ras VARCHAR(50))
AS
BEGIN

    SELECT Regnummer, hund.Namn, Tat_ID, Chip_ID, Kön, ras.namn as Ras FROM Hund
    INNER JOIN RAS ON Ras.Ras_ID = Hund.Ras
    WHERE LOWER(Ras.namn) LIKE LOWER( '%' + @Ras + '%' )
	-- Implementera
	-- hundar.skk.se/hunddata/Hund_sok.aspx
	RETURN 

END
GO
CREATE OR ALTER PROCEDURE Dog_Find 
	@RegNr varchar(50) = null, 
	@Namn varchar(50) = null,
    @Kön char = null,
    @Tat_ID varchar(20) = null,
    @Ras varchar(50) = null,
    @Chip_ID varchar(20) = null
AS
BEGIN
	SELECT Regnummer, Hund.Namn, Tat_ID, Chip_ID, Kön, Ras.Namn as Ras FROM Hund
    INNER JOIN Ras
    ON Hund.Ras = Ras.Ras_ID

    WHERE  LOWER(Regnummer) LIKE ISNULL(LOWER('%' + @RegNr + '%'), Regnummer) 
    AND LOWER(Hund.Namn) LIKE ISNULL(LOWER('%' + @Namn + '%'), Hund.Namn)
    AND Kön = ISNULL(@Kön, Kön)
    AND (@Ras IS NULL OR LOWER(Ras.namn) LIKE LOWER('%' + @Ras + '%'))
    AND  (@Tat_ID IS NULL OR LOWER(Tat_ID) LIKE  LOWER('%' + @Tat_ID + '%'))
    AND (@Chip_ID IS NULL OR LOWER(Chip_ID) LIKE LOWER('%' + @Chip_ID + '%'))
	RETURN 

END

GO
CREATE OR ALTER PROCEDURE Dog_GetInfo
    (@DogId int)
AS
BEGIN

    SELECT h1.Regnummer + ' ' + h1.namn 'Hund',
        Ras.namn 'Ras',
        h1.Kön as Kön,
        (SELECT h2.Regnummer + ' ' + h2.namn FROM Hund h2 
        JOIN Hund_Kull ON Hund_Kull.Hund_ID = h2.Hund_ID
        WHERE Hund_Kull.Roll = 'M'
        AND h2.Hund_ID <> h1.Hund_ID
        AND Hund_Kull.Kull_ID = (SELECT Hund_Kull.Kull_ID FROM Hund_Kull WHERE Hund_Kull.Hund_ID = h1.Hund_ID 
                                                                           AND Hund_Kull.Roll = 'B' 
                                                                           AND H1.hund_id = Hund_Kull.Hund_ID)) AS Mor,


    (SELECT h2.Regnummer + ' ' +  h2.namn FROM Hund h2 
        JOIN Hund_Kull ON Hund_Kull.Hund_ID = h2.Hund_ID
        WHERE Hund_Kull.Roll = 'F' 
        AND h2.Hund_ID <> h1.Hund_ID
        AND Hund_Kull.Kull_ID = (SELECT Hund_Kull.Kull_ID FROM Hund_Kull WHERE Hund_Kull.Hund_ID = h1.Hund_ID
                                                                           AND Hund_Kull.Roll = 'B' 
                                                                           AND H1.hund_id = Hund_Kull.Hund_ID)) AS Far,
    Kull.Datum AS 'Födelsedatum',
    h1.Tat_ID,
    h1.Chip_ID,
    h1.Färg
    
    FROM HUND h1
    JOIN Ras on Ras_ID = h1.Ras
    JOIN Hund_Kull on h1.Hund_ID = Hund_Kull.Hund_ID
    LEFT JOIN Kull ON Hund_Kull_ID = kull.Kull_ID
    WHERE h1.Hund_ID = @DogId

    RETURN 
END

GO

CREATE OR ALTER PROCEDURE Dog_GetOwner
	@DogId int
AS
BEGIN

    SELECT Person.Namn FROM PERSON 
    INNER JOIN Hund 
    ON Person.Person_ID = Hund.Ägare
    WHERE Hund.Hund_ID = @DogId 

	-- Implementera
	-- https://hundar.skk.se/hunddata/Hund.aspx?hundid=2201379
	-- Fliken Ägare
	RETURN 

END

GO

CREATE OR ALTER PROCEDURE Dog_GetJournal
    @DogId int
AS
BEGIN
    SELECT Veterinär_Historik.Datum, Veterinär_Historik.Klinik + ' ' + (SELECT DISTINCT(Person.Namn) FROM Person INNER JOIN Veterinär_Historik
    ON Person.Person_ID = Veterinär_Historik.Veterinär
    WHERE Veterinär_Historik.Hund_ID = 1) 'Veterinär/Klinik', Veterinär_Historik.Resultat
    FROM Veterinär_Historik
    WHERE Veterinär_Historik.Hund_ID = @DogId

    -- Implementera
    -- https://hundar.skk.se/hunddata/Hund.aspx?hundid=2201379
    -- Fliken Vetrinär
    RETURN 

END
GO

CREATE OR ALTER PROCEDURE Dog_GetBreeder
	@DogId int
AS
BEGIN
    SELECT Kennel.Namn Kennel, Person.Namn Uppfödare, Kennel.Ort FROM Person
    INNER JOIN Kull 
    ON Person.Person_ID = Kull.Uppfödare
    INNER JOIN Kennel 
    ON Kull.Kennel = Kennel.Kennel_ID
    INNER JOIN Hund_Kull
    ON Kull.Kull_ID = Hund_Kull.Kull_ID
    WHERE Hund_Kull.Hund_ID = @DogId
    

	-- Implementera
	-- https://hundar.skk.se/hunddata/Hund.aspx?hundid=2201379
	-- Fliken Uppfödare
	RETURN 

END

GO


CREATE OR ALTER PROCEDURE Dog_GetLittermates
	@DogId int
AS
BEGIN

    SELECT h1.Regnummer, h1.Namn, h1.Kön FROM Hund h1 
    INNER JOIN Hund_Kull 
    ON h1.Hund_ID = Hund_Kull.Hund_ID
    
    WHERE (SELECT Hund_Kull.Kull_ID FROM Hund_Kull 
    WHERE Hund_Kull.Hund_ID=@DogId AND Hund_Kull.Roll = 'B') = Hund_Kull.Kull_ID
    AND Hund_Kull.Roll = 'B' AND Hund_Kull.Hund_ID <> @DogId
    RETURN 
END


GO

CREATE OR ALTER PROCEDURE Dog_GetOffspring
	@DogId int
AS
BEGIN
    SELECT h1.Regnummer, h1.Namn, h1.Kön, kull.Datum as 'Födelsedatum',
       CASE 
       WHEN (SELECT Kön FROM hund WHERE Hund_ID = @DogId) = 'H'
            THEN (SELECT h2.Regnummer + ' ' + h2.namn FROM Hund h2 
            JOIN Hund_Kull ON Hund_Kull.Hund_ID = h2.Hund_ID
            WHERE Hund_Kull.Roll = 'M'
            AND h2.Hund_ID <> h1.Hund_ID
            AND Hund_Kull.Kull_ID = (SELECT Hund_Kull.Kull_ID FROM Hund_Kull WHERE Hund_Kull.Hund_ID = h1.Hund_ID 
                                                                           AND Hund_Kull.Roll = 'B' 
                                                                           AND H1.hund_id = Hund_Kull.Hund_ID)) 
       ELSE  (SELECT h2.Regnummer + ' ' +  h2.namn FROM Hund h2 
        JOIN Hund_Kull ON Hund_Kull.Hund_ID = h2.Hund_ID
        WHERE Hund_Kull.Roll = 'F' 
        AND h2.Hund_ID <> h1.Hund_ID
        AND Hund_Kull.Kull_ID = (SELECT Hund_Kull.Kull_ID FROM Hund_Kull WHERE Hund_Kull.Hund_ID = h1.Hund_ID
                                                                           AND Hund_Kull.Roll = 'B' 
                                                                           AND H1.hund_id = Hund_Kull.Hund_ID))
       END AS Partner

    FROM Hund h1
    INNER JOIN Hund_Kull
    JOIN KULL ON Kull.Kull_ID = Hund_Kull.Kull_ID
    ON h1.Hund_ID = Hund_Kull.Hund_ID
    WHERE (SELECT Hund_Kull.Kull_ID FROM Hund_Kull WHERE Hund_Kull.Hund_ID = @DogId
    AND Hund_Kull.Roll <> 'B') = Hund_Kull.Kull_ID
    AND Hund_Kull.Roll = 'B' 

	-- Implementera
	-- https://hundar.skk.se/hunddata/Hund.aspx?hundid=2201379
	-- Fliken avkommor
	RETURN 
END

GO

-- Övriga funktioner

CREATE OR ALTER PROCEDURE Dog_Add 
    @RegNr varchar(20), 
    @PersonNr varchar(20),
    @Ras varchar(50),
    @Namn varchar(50),
    @Kön char,
    @Tat_ID varchar(20),
    @Chip_ID varchar(20),
    @Färg varchar(20)
AS
BEGIN
    INSERT INTO Hund (Regnummer, Ägare, Ras, Namn, Kön, Tat_ID, Chip_ID, Färg) 
    VALUES (@RegNr, (SELECT Person.Person_ID FROM Person WHERE Person.Personnummer = @PersonNr), (SELECT Ras.Ras_ID FROM Ras WHERE Ras.namn = @Ras), @Namn, @Kön, @Tat_ID, @Chip_ID, @Färg)
	RETURN 

END


GO

CREATE OR ALTER PROCEDURE Owner_Add 
	@Namn varchar(50), 
    @PersonNr varchar(20)
AS
BEGIN

    DECLARE @Id int

	INSERT INTO Person(Namn, Personnummer) VALUES (@Namn, @PersonNr)
    SET @Id = (SELECT Person.Person_ID FROM Person WHERE Personnummer = @PersonNr)
    INSERT INTO Roll_Person (Person_ID, Roll_ID) VALUES(@Id, '3')
	RETURN 

END

GO

CREATE OR ALTER PROCEDURE Dog_ChangeOwner
	@RegNr varchar(20),
    @PersonNr varchar(20)
AS
BEGIN
    UPDATE Hund SET Ägare = (SELECT Person.Person_ID FROM Person WHERE Person.Personnummer = @PersonNr) 
    WHERE Hund.Regnummer = @RegNr

	-- Implementera
	RETURN 

END

GO

CREATE OR ALTER PROCEDURE Dog_ReportMissing
    @Regno VARCHAR(50),
    @Datum DATE = NULL
AS

BEGIN
    SET @Datum = ISNULL(@Datum,GETDATE())
    INSERT INTO Saknad_Historik (Hund_ID, Försvunnen) VALUES ((SELECT Hund.Hund_ID FROM HUND WHERE Regnummer = @Regno), @Datum)
    
    RETURN 

END

GO

CREATE OR ALTER PROCEDURE Dog_ReportFound
    @Regno VARCHAR(50),
    @Datum DATE = NULL
AS
BEGIN
    SET @Datum = ISNULL(@Datum,GETDATE())
    UPDATE Saknad_Historik 
    SET Upphittad = @Datum
    WHERE Hund_ID = (SELECT Hund_ID FROM Hund WHERE Regnummer = @Regno)
    RETURN 

END
GO

-- CREATE OR ALTER TRIGGER CheckUniqueParent
-- ON Hund_Kull
-- AFTER INSERT, UPDATE
-- AS
--     IF EXISTS(SELECT * FROM Hund_Kull 
--               JOIN inserted on Hund_kull.Kull_ID = inserted.Kull_ID
--               WHERE inserted.Roll = Hund_Kull.Roll 
--               AND inserted.Roll <> 'B'
--               AND inserted.Kull_ID = Hund_Kull.Kull_ID)
--     BEGIN
--     ROLLBACK TRANSACTION;
--     return;
-- END


-- PROCEDURES END
