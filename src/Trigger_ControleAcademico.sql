CREATE OR ALTER TRIGGER TGR_Media_Insert ON Disciplina_Matricula AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Nota2))
    BEGIN
        DECLARE @id INT, @Sigla char(7), @Nota1 DECIMAL(4,2), @Nota2 DECIMAL(4,2), @Media DECIMAL(4,2)

        SELECT @id = ID_DM, @Sigla = Sigla_DM, @Nota1 = Nota1, @Nota2 = Nota2 FROM inserted

        SET @Media = (@Nota1+@Nota2)/2
        UPDATE [dbo].[Disciplina_Matricula] SET Media = @Media WHERE ID_DM = @id AND Sigla_DM = @Sigla
    END
END;
GO

CREATE OR ALTER TRIGGER TGR_Situacao_Update ON Disciplina_Matricula AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Media))
    BEGIN
        DECLARE @id INT, @Sigla char(7), @Situacao varchar(19), @Media DECIMAL(4,2)

        SELECT @id = ID_DM, @Sigla = Sigla_DM, @Situacao = Situacao, @Media = Media FROM inserted

        SET @Situacao = CASE
            WHEN (@Media >= 5) THEN 'Aprovado'
            ELSE 'Reprovado'
        END

        UPDATE Disciplina_Matricula SET Situacao = @Situacao WHERE ID_DM = @id AND Sigla_DM = @Sigla
    END
END;
GO

CREATE OR ALTER TRIGGER TGR_Presença_Update ON Disciplina_Matricula AFTER UPDATE
AS
BEGIN
    IF (UPDATE(Falta))
    BEGIN   
        DECLARE @id INT, @Sigla char(7), @Falta int, @Situacao VARCHAR(19), @CargaHoraria int

        SELECT @id = i.ID_DM, @Sigla = i.Sigla_DM, @Falta = i.Falta, @Situacao = i.Situacao, @CargaHoraria = d.CargaHoraria FROM inserted i join Disciplina d
        on d.Sigla = i.Sigla_DM

        IF((@Falta > @CargaHoraria/2))  
        BEGIN
            set @Situacao = 'Reprovado por falta'
        END

        UPDATE Disciplina_Matricula SET Situacao = @Situacao WHERE ID_DM = @id AND Sigla_DM = @Sigla
    END
END;
GO