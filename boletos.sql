DECLARE @DATA DATETIME
SET @DATA = '2017-31-12'


SELECT
SCONTRATO.RA,
SCONTRATO.CODCONTRATO,
SPLETIVO.DESCRICAO,
CONVERT(VARCHAR,SPARCELA.DTCOMPETENCIA,103) AS 'COMPETENCIA',
CONVERT(VARCHAR,SPARCELA.DTVENCIMENTO,103) AS 'VENCIMENTO',
CONVERT(VARCHAR,FLAN.DATABAIXA,103) AS 'DATA DA BAIXA',
CONVERT(VARCHAR,FLAN.DATACANCELAMENTO,103) AS 'DATA CANCELAMENTO',
FLAN.VALORORIGINAL,
FLAN.VALORBAIXADO
FROM SCONTRATO

INNER JOIN SPLETIVO ON 
	SPLETIVO.CODCOLIGADA 	= SCONTRATO.CODCOLIGADA
AND SPLETIVO.IDPERLET 		= SCONTRATO.IDPERLET

INNER JOIN SPARCELA ON
	SPARCELA.CODCOLIGADA 	= SCONTRATO.CODCOLIGADA 
AND SPARCELA.RA 			= SCONTRATO.RA 
AND SPARCELA.CODCONTRATO 	= SCONTRATO.CODCONTRATO 
AND SPARCELA.IDPERLET 		= SCONTRATO.IDPERLET

INNER JOIN SLAN ON 
SLAN.CODCOLIGADA = SPARCELA.CODCOLIGADA AND 
SLAN.IDPARCELA = SPARCELA.IDPARCELA

INNER JOIN FLAN ON 
FLAN.IDLAN = SLAN.IDLAN AND
FLAN.CODCOLIGADA = SLAN.CODCOLIGADA

INNER JOIN FBOLETO ON
FBOLETO.CODCOLIGADA = FLAN.CODCOLIGADA AND
FBOLETO.IDBOLETO = FLAN.IDBOLETO

WHERE SCONTRATO.CODFILIAL = 3 AND
CONVERT(DATE,SPARCELA.DTVENCIMENTO) <= @DATA
AND FLAN.DATACANCELAMENTO IS NULL
AND FLAN.DATABAIXA IS NULL