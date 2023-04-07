CREATE OR ALTER PROC InsertAluno @Name VARCHAR(50), @CPF CHAR(11), @BirthDate DATE
AS
BEGIN
    INSERT into Aluno (RA, nome, CPF, DataNascimento)VALUES (
        NEWID(),
        @Name,
        @CPF,
        @BirthDate
    )
END
GO

CREATE OR ALTER PROC InsertNota @ID int, @Sigla char(7), @Nota1 NUMERIC(4,2), @Nota2 NUMERIC(4,2)
AS
BEGIN
    UPDATE [dbo].[Disciplina_Matricula]
    SET
        [Nota1] = @Nota1,
        [Nota2] = @Nota2
    WHERE ID_DM = @ID AND Sigla_DM = @Sigla
END
GO

CREATE OR ALTER PROC CalcMedia
AS
BEGIN
    DECLARE @Media DECIMAL(4,2), @Nota1 DECIMAL(4,2), @Nota2 DECIMAL(4,2), @Id INT, @Sigla CHAR(7)

    SELECT @id = ID_DM, @Sigla = Sigla_DM, @Nota1 = Nota1, @Media = Media, @Nota2 = Nota2 FROM Disciplina_Matricula

    SET @Media = (@Nota1 + @Nota2)/2

    UPDATE [dbo].[Disciplina_Matricula]
    SET
        [Media] = @Media
    WHERE ID_DM = @ID AND Sigla_DM = @Sigla
END
GO

CREATE OR ALTER PROC [dbo].[InsertSitaution]
AS
BEGIN
INSERT INTO [dbo].[Disciplina_Matricula] (Situacao) VALUES ('Reprovado por falta')
END
GO

CREATE OR ALTER PROC InsertNotaSub @ID int, @Sigla char(7), @Sub NUMERIC(4,2)
AS
BEGIN
    UPDATE [dbo].[Disciplina_Matricula]
    SET
        [Sub] = @Sub
    WHERE ID_DM = @ID AND Sigla_DM = @Sigla
END
GO

CREATE OR ALTER PROC IniciarSemestre
AS
BEGIN
    UPDATE Disciplina_Matricula SET
    Nota1 = null, Nota2 = null,
    Sub = null, Falta = 0, Media = null, Situacao = 'Matriculado'
END
GO

CREATE OR ALTER PROC MatricularAluno @IdMatricula INT, @Sigla CHAR(7)
AS
BEGIN
    DECLARE @id INT

    SELECT @id = ID FROM Matricula WHERE ID = @IdMatricula
    IF (@id is null)
    BEGIN
        PRINT('Não existe o aluno matriculado')
    END
    ELSE
    BEGIN
        INSERT INTO Disciplina_Matricula (ID_DM, Sigla_DM, Situacao, Falta) VALUES (
            @IdMatricula, @Sigla, 'Matriculado', 0
        ) 
        PRINT('Aluno matriculado com sucesso')
    END
END
GO

CREATE OR ALTER PROC CadastrarMatricula @RA UNIQUEIDENTIFIER, @Ano int, @Semestre int
AS
BEGIN
    INSERT INTO [dbo].[Matricula]
    (
    [RA_Matricula], [Ano], [Semestre]
    )
    VALUES
    (
    @RA, @Ano, @Semestre
    )
END