--DDL Script


use OOP_BLÅ

DROP TABLE Multiple_Choice_Answer;
DROP TABLE Multiple_Choice_Question;
DROP TABLE Scale_Question_Answer;
DROP TABLE Scale_Question;
DROP TABLE Free_Text_Question;
DROP TABLE True_False_Question;
DROP TABLE Question;
DROP TABLE User_Survey;
DROP TABLE Survey;
DROP TABLE [User];

CREATE TABLE Survey(
    ID int PRIMARY KEY IDENTITY(1,1),
    Title Varchar(50),
);

CREATE TABLE [User](
    ID int PRIMARY KEY IDENTITY(1,1),
    SSN Varchar(50) UNIQUE,
    PW VARCHAR(100),
    Salt VARCHAR(50)
);

CREATE TABLE User_Survey(
    ID int PRIMARY KEY IDENTITY(1,1),
    Survey_ID int FOREIGN KEY REFERENCES Survey(ID),
    User_ID int FOREIGN KEY REFERENCES [User](ID),
    IsSubmitted bit,
    User_Specific_Code VARCHAR(100) UNIQUE
);

CREATE TABLE Question(
    ID int PRIMARY KEY IDENTITY(1,1),
    Survey_ID int FOREIGN KEY REFERENCES Survey(ID),
    [Type] int,
    QuestionText VARCHAR(50)
);

CREATE TABLE True_False_Question(
    ID int PRIMARY KEY IDENTITY(1,1),
    Question_ID int FOREIGN KEY REFERENCES Question(ID),
    Answer BIT
);

CREATE TABLE Free_Text_Question(
    ID int PRIMARY KEY IDENTITY(1,1),
    Question_ID int FOREIGN KEY REFERENCES Question(ID),
    Answer VARCHAR(200)
);

CREATE TABLE Scale_Question(
    ID int PRIMARY KEY IDENTITY(1,1),
    Question_ID int FOREIGN KEY REFERENCES Question(ID),
    Value_1 VARCHAR(50),
    Value_10 VARCHAR(50),
);

CREATE TABLE Scale_Question_Answer(
    ID int PRIMARY KEY IDENTITY(1,1),
    Scale_Question_ID int FOREIGN KEY REFERENCES Scale_Question(ID),
    Answer INT 
);

CREATE TABLE Multiple_Choice_Question(
    ID int PRIMARY KEY IDENTITY(1,1),
    Question_ID int FOREIGN KEY REFERENCES Question(ID),
    Alternative VARCHAR(50)
);

CREATE TABLE Multiple_Choice_Answer(
    ID int PRIMARY KEY IDENTITY(1,1),
    Multiple_Choice_Question_ID int FOREIGN KEY REFERENCES Multiple_Choice_Question(ID),
    Answer BIT
);

CREATE INDEX Idx_Survey_Title
ON Survey(Title);

CREATE INDEX Idx_User_Ssn
ON [User](SSN);

CREATE INDEX Idx_User_Survey_Survey_ID
ON User_Survey(Survey_ID);

CREATE INDEX Idx_User_Survey_User_ID
ON User_Survey(User_ID);

CREATE INDEX Idx_User_Survey_User_Specific_Code
ON User_Survey(User_Specific_Code);

CREATE INDEX Idx_True_False_Question_Question_ID
ON True_False_Question(Question_ID);

CREATE INDEX Idx_Free_Text_Question_Question_ID
ON Free_Text_Question(Question_ID);

CREATE INDEX Idx_Scale_Question_Question_ID
ON Scale_Question(Question_ID);

CREATE INDEX Idx_Scale_Question_Answer_Scale_Question_ID
ON Scale_Question_Answer(Scale_Question_ID);

CREATE INDEX Idx_Multiple_Choice_Question_Question_ID
ON Multiple_Choice_Question(Question_ID);

CREATE INDEX Idx_Multiple_Choice_Answer_Multiple_Choice_Question_ID
ON Multiple_Choice_Answer(Multiple_Choice_Question_ID);


--DDL Script ends
