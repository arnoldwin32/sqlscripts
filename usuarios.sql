DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = '2018-01-06'
SET @DATAATE = '2018-30-06'

SELECT 
DISTINCT
GFILIAL.NOMEFANTASIA AS 'Unidade',
SMODALIDADECURSO.DESCRICAO AS 'MODALIDADE',
SCURSO.NOME AS 'Curso',
SALUNO.RA,
PPESSOA.NOME,
FCFO.CGCCFO AS 'CPF',
FCFO.NOME AS 'Nome RespFin',
STURMA.CODTURMA,
CONVERT(VARCHAR(10),STURMA.DTINICIAL,103) AS 'Data Inicial',
CONVERT(VARCHAR(10),STURMA.DTFINAL,103) AS 'Data Final',
SSTATUS.DESCRICAO AS 'Situa��o',
GCONSIST.DESCRICAO AS 'TipoGratuidade',
FCFO.CODUSUARIOACESSO,
FCFO.EMAIL,
GF.NOMEFANTASIA AS 'Filial do Usu�rio'


FROM SMATRICPL

JOIN SHABILITACAOALUNO ON SHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SHABILITACAOALUNO.RA = SMATRICPL.RA
JOIN SHABILITACAOALUNOCOMPL ON SHABILITACAOALUNOCOMPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL AND SHABILITACAOALUNOCOMPL.RA = SHABILITACAOALUNO.RA
JOIN STURMA ON STURMA.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND STURMA.CODFILIAL = SMATRICPL.CODFILIAL AND STURMA.CODTURMA = SMATRICPL.CODTURMA AND STURMA.IDPERLET = SMATRICPL.IDPERLET
JOIN STURMACOMPL ON STURMACOMPL.CODCOLIGADA = STURMA.CODCOLIGADA AND STURMACOMPL.CODFILIAL = STURMA.CODFILIAL AND STURMACOMPL.CODTURMA = STURMA.CODTURMA AND STURMACOMPL.IDPERLET = STURMA.IDPERLET
JOIN SALUNO ON SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SALUNO.RA = SHABILITACAOALUNO.RA
JOIN SHABILITACAOFILIAL ON SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
LEFT JOIN SCONTRATO ON SCONTRATO.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SCONTRATO.IDPERLET = SMATRICPL.IDPERLET AND SCONTRATO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SCONTRATO.RA = SMATRICPL.RA
LEFT JOIN SRESPONSAVELCONTRATO ON SRESPONSAVELCONTRATO.CODCOLIGADA = SCONTRATO.CODCOLIGADA AND SRESPONSAVELCONTRATO.RA = SCONTRATO.RA AND SRESPONSAVELCONTRATO.CODCONTRATO = SCONTRATO.CODCONTRATO AND SRESPONSAVELCONTRATO.IDPERLET = SCONTRATO.IDPERLET
LEFT JOIN FCFO ON FCFO.CODCOLIGADA = SRESPONSAVELCONTRATO.CODCOLCFO AND FCFO.CODCFO = SRESPONSAVELCONTRATO.CODCFO
LEFT JOIN GUSUARIO ON GUSUARIO.CODUSUARIO = FCFO.CODUSUARIOACESSO
JOIN PPESSOA ON PPESSOA.CODIGO = SALUNO.CODPESSOA
JOIN GFILIAL ON SMATRICPL.CODCOLIGADA = GFILIAL.CODCOLIGADA AND SMATRICPL.CODFILIAL = GFILIAL.CODFILIAL
JOIN SGRADE ON SGRADE.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA AND SGRADE.CODCURSO = SHABILITACAOFILIAL.CODCURSO AND SGRADE.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO AND SGRADE.CODGRADE = SHABILITACAOFILIAL.CODGRADE
JOIN SHABILITACAO ON SHABILITACAO.CODCOLIGADA = SGRADE.CODCOLIGADA AND SHABILITACAO.CODCURSO = SGRADE.CODCURSO AND SHABILITACAO.CODHABILITACAO = SGRADE.CODHABILITACAO
JOIN SCURSO ON SCURSO.CODCOLIGADA = SHABILITACAO.CODCOLIGADA AND SCURSO.CODCURSO = SHABILITACAO.CODCURSO
JOIN SMODALIDADECURSO ON SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
LEFT JOIN GCONSIST ON GCONSIST.CODINTERNO = SHABILITACAOALUNOCOMPL.TIPOGRAT AND GCONSIST.CODTABELA = 'TIPOGRAT'
INNER JOIN SSTATUS ON SSTATUS.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS
LEFT JOIN SUSUARIOFILIAL ON SUSUARIOFILIAL.CODUSUARIO = GUSUARIO.CODUSUARIO
LEFT JOIN GFILIAL GF ON SUSUARIOFILIAL.CODCOLIGADA = GF.CODCOLIGADA AND SUSUARIOFILIAL.CODFILIAL = GF.CODFILIAL

WHERE

SMATRICPL.CODCOLIGADA = 3

AND STURMA.DTFINAL >= @DATADE AND STURMA.DTINICIAL <= @DATAATE 
AND SMATRICPL.CODSTATUS = 2
AND FCFO.PESSOAFISOUJUR = 'F'
--AND SMATRICPL.CODFILIAL = 3
AND STURMACOMPL.TIPOTURMA NOT IN ('2','11','12')
AND SMODALIDADECURSO.CODMODALIDADECURSO NOT IN ('11','15')
AND SHABILITACAOALUNOCOMPL.ARTICULACAO != 1
AND GFILIAL.CODFILIAL != GF.CODFILIAL