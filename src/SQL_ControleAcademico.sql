CREATE DATABASE ControleAcademico
GO
USE ControleAcademico
GO


CREATE TABLE [dbo].[Aluno]
(
    [RA] UNIQUEIDENTIFIER NOT NULL,
    [CPF] CHAR(11) NOT NULL,
    [Nome] VARCHAR(50) NOT NULL,
    [DataNascimento] DATE not NULL
    -- Specify more columns here

    CONSTRAINT PK_Aluno PRIMARY KEY (RA),
    CONSTRAINT UN_Aluno UNIQUE (CPF)
)
GO

CREATE TABLE [dbo].[Disciplina]
(
    [Sigla] Char(7) NOT NULL,
    [Nome] VARCHAR(50) NOT NULL,
    [CargaHoraria] INT not NULL
    -- Specify more columns here

    CONSTRAINT PK_Disciplina PRIMARY KEY (Sigla)
)
GO

CREATE TABLE [dbo].[Matricula]
(
    [ID] int IDENTITY(1,1) NOT NULL,
    [RA_Matricula] UNIQUEIDENTIFIER not NULL,
    [Ano] int NOT NULL,
    [Semestre] INT not NULL
    -- Specify more columns here

    CONSTRAINT PK_Matricula PRIMARY KEY (ID),
    CONSTRAINT FK_Matricula_Aluno FOREIGN KEY (RA_Matricula) REFERENCES Aluno (RA),
    CONSTRAINT UN_Matricula UNIQUE (RA_Matricula, Ano, Semestre)
)
GO

CREATE TABLE [dbo].[Disciplina_Matricula]
(
    [ID_DM] int NOT NULL,
    [Sigla_DM] CHAR(7) not NULL,
    [Situacao] VARCHAR(19) NULL,
    [Falta] INT NULL,
    [Nota1] NUMERIC(4,2) NULL,
    [Nota2] NUMERIC(4,2) NULL,
    [Sub] NUMERIC(4,2) NULL
    -- Specify more columns here

    CONSTRAINT PK_Disciplina_Matricula PRIMARY KEY (ID_DM, Sigla_DM),
    CONSTRAINT FK_Matricula_Disciplina FOREIGN KEY (ID_DM) REFERENCES Matricula (ID),
    CONSTRAINT FK_Disciplina_Matricula FOREIGN KEY (Sigla_DM) REFERENCES Disciplina (Sigla)
)
GO

INSERT into Aluno (RA, nome, CPF, DataNascimento)VALUES (
    NEWID(),
    'Giovani',
    '46615304899',
    '1999-05-29'
)
INSERT into Aluno (RA, nome, CPF, DataNascimento)VALUES (
    NEWID(),
    'Ana Maria',
    '16598437440',
    '1996-12-15'
)
INSERT into Aluno (RA, nome, CPF, DataNascimento)VALUES (
    NEWID(),
    'Fernando',
    '12345678901',
    '2000-09-15'
)

INSERT INTO Disciplina VALUES ('SEM1234', 'Mecânica dos solidos', 60), ('SEM9087', 'Mecanica dos fluidos', 80), ('IOT1526', 'Internet das coisas', 120)

INSERT INTO Matricula VALUES ('5394fd2a-668a-4ada-9852-c26461ba4fa5', 2023, 1)
INSERT INTO Matricula VALUES ('5394fd2a-668a-4ada-9852-c26461ba4fa5', 2023, 2)
INSERT INTO Matricula VALUES ('e4818623-d9b8-4723-8daa-566512dbb531', 2023, 1)
INSERT INTO Matricula VALUES ('e4818623-d9b8-4723-8daa-566512dbb531', 2023, 2)
INSERT INTO Matricula VALUES ('4d89c05e-a5b3-42f9-88e4-653dbc881afd', 2023, 1)


UPDATE [dbo].[Disciplina]
SET
    [Nome] = 'Mecânica dos solidos',
    [CargaHoraria] = 60
WHERE Sigla = 'SEM1234'
GO


INSERT INTO [dbo].[Disciplina_Matricula]
(
 [ID_DM], [Sigla_DM], [Falta], [Situacao]
)
VALUES
(
 1, 'BDR3512', 3, 'Matriculado'
)
GO

INSERT INTO [dbo].[Disciplina_Matricula]
(
 [ID_DM], [Sigla_DM], [Falta], [Situacao]
)
VALUES
(
 1, 'DIA6584', 0, 'Matriculado'
)
GO

INSERT INTO [dbo].[Matricula]
(
  [RA_Matricula], [Ano], [Semestre]
)
VALUES
(
 '67b7ff2b-a03e-4104-af98-832041355629', 2023, 1
),
(
 '6ec65767-c309-47ab-ab41-584599baf1de', 2023, 1
),
(
  '0f048cf4-8817-4db5-a7a0-c3a6b617e416', 2023, 1
)
GO

SELECT * FROM Matricula
SELECT * FROM Aluno

SELECT m.Ano, m.Semestre, a.Nome, d.Nome, dm.Media, dm.Situacao
FROM Aluno a join Matricula m on a.RA = m.RA_Matricula
    join Disciplina_Matricula dm on m.ID = dm.ID_DM
    join Disciplina d on dm.Sigla_DM = d.Sigla
ORDER BY a.Nome

EXEC.InsertNota 1, 'BDR3512', 3, 4

EXEC.CalcMedia

UPDATE [dbo].[Disciplina_Matricula]
SET
    [Falta] = 60
WHERE ID_DM = 1 AND Sigla_DM = 'DIA6584'

EXEC.IniciarSemestre

Exec.MatricularAluno 10, 'SEM1234'

EXEC.CadastrarMatricula '67b7ff2b-a03e-4104-af98-832041355629', 2023, 1