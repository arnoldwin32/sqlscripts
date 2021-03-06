DECLARE @DE DATETIME
DECLARE @ATE DATETIME

SET @DE = '2018-01-01'
SET @ATE = sysdatetime()

SELECT
	GFILIAL.NOMEFANTASIA AS 'Unidade',
	SMP.CODTURMA   AS 'Turma',
	CONVERT(VARCHAR(10),STURMA.DTINICIAL,103) AS 'Data inicial',
	CONVERT(VARCHAR(10),STURMA.DTFINAL,103)AS 'Data Final',
	SMP.RA         AS 'Registro Acad�mico',
	PP.NOME        AS 'Aluno',
	SC.CODCONTRATO AS 'Contrato',
	SP.PARCELA     AS 'Parcela',
	SL.IDLAN,
	CASE
	WHEN
		FL.STATUSLAN = 0
	THEN
		'Em Aberto'
	WHEN
		FL.STATUSLAN = 1
	THEN
		'Baixado'
	WHEN
		FL.STATUSLAN = 2
	THEN	
		'Cancelado'
	WHEN
		FL.STATUSLAN = 3
	THEN
		'Baixado por Acordo'
	WHEN
		FL.STATUSLAN = 4
	THEN
		'Baixado Parcialmente'
	WHEN
		FL.STATUSLAN = 5
	THEN
		'Border�'
	END AS 'Status Parcela',
	CONVERT(VARCHAR,SP.DTVENCIMENTO,103) AS 'Vencimento',
	SP.VALOR AS 'Valor Parcela',
	FL.VALORBAIXADO,
	CASE FCFO.PESSOAFISOUJUR
		WHEN 'J' THEN 'PJ'
		WHEN 'F' THEN 'PF'
	ELSE NULL
	END AS 'TIPO DE CLIENTE',
	SS.NOME  AS 'Descri��o do Servi�o',
	SMODALIDADECURSO.DESCRICAO AS 'Modalidade'
FROM
	SMATRICPL SMP (NOLOCK)
INNER JOIN
	SALUNO SA (NOLOCK) ON
	SA.CODCOLIGADA          = SMP.CODCOLIGADA
AND SA.RA                   = SMP.RA

INNER JOIN STURMA ON 
STURMA.CODCOLIGADA = SMP.CODCOLIGADA AND 
STURMA.CODFILIAL = SMP.CODFILIAL AND 
STURMA.CODTURMA = SMP.CODTURMA AND 
STURMA.IDPERLET = SMP.IDPERLET AND
STURMA.IDHABILITACAOFILIAL = SMP.IDHABILITACAOFILIAL

INNER JOIN
	PPESSOA PP (NOLOCK) ON
	PP.CODIGO               = SA.CODPESSOA
INNER JOIN
	SHABILITACAOFILIAL SHF (NOLOCK) ON
	SHF.CODCOLIGADA			= SMP.CODCOLIGADA
AND SHF.CODFILIAL			= SMP.CODFILIAL
AND SHF.IDHABILITACAOFILIAL = SMP.IDHABILITACAOFILIAL
INNER JOIN SGRADE ON SGRADE.CODCOLIGADA = SHF.CODCOLIGADA AND SGRADE.CODCURSO = SHF.CODCURSO AND SGRADE.CODHABILITACAO = SHF.CODHABILITACAO AND SGRADE.CODGRADE = SHF.CODGRADE
INNER JOIN SHABILITACAO ON SHABILITACAO.CODCOLIGADA = SGRADE.CODCOLIGADA AND SHABILITACAO.CODCURSO = SGRADE.CODCURSO AND SHABILITACAO.CODHABILITACAO = SGRADE.CODHABILITACAO
INNER JOIN SCURSO ON SCURSO.CODCOLIGADA = SHABILITACAO.CODCOLIGADA AND SCURSO.CODCURSO = SHABILITACAO.CODCURSO
INNER JOIN SMODALIDADECURSO ON SMODALIDADECURSO.CODCOLIGADA = SCURSO.CODCOLIGADA AND SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO
INNER JOIN
	SCONTRATO SC (NOLOCK) ON
	SC.CODCOLIGADA          = SMP.CODCOLIGADA
AND SC.CODFILIAL            = SMP.CODFILIAL
AND SC.IDPERLET             = SMP.IDPERLET
AND SC.IDHABILITACAOFILIAL  = SMP.IDHABILITACAOFILIAL
AND SC.RA                   = SMP.RA

INNER JOIN SRESPONSAVELCONTRATO ON 
	SRESPONSAVELCONTRATO.CODCOLIGADA = SC.CODCOLIGADA 
AND SRESPONSAVELCONTRATO.RA = SC.RA 
AND SRESPONSAVELCONTRATO.CODCONTRATO = SC.CODCONTRATO 
AND SRESPONSAVELCONTRATO.IDPERLET = SC.IDPERLET

INNER JOIN FCFO  (NOLOCK) ON 
	FCFO.CODCOLIGADA = SRESPONSAVELCONTRATO.CODCOLCFO	
AND FCFO.CODCFO = SRESPONSAVELCONTRATO.CODCFO

INNER JOIN
	SPARCELA SP (NOLOCK) ON
	SP.CODCOLIGADA          = SC.CODCOLIGADA
AND SP.CODCONTRATO          = SC.CODCONTRATO
AND SP.IDPERLET             = SC.IDPERLET
AND SP.RA                   = SC.RA
LEFT JOIN
	SLAN SL (NOLOCK) ON
	SL.CODCOLIGADA          = SP.CODCOLIGADA
AND SL.IDPARCELA            = SP.IDPARCELA
LEFT JOIN
	FLAN FL (NOLOCK) ON
	FL.CODCOLIGADA          = SL.CODCOLIGADA
AND FL.IDLAN                = SL.IDLAN
INNER JOIN
	SSERVICO SS (NOLOCK) ON
	SS.CODCOLIGADA          = SP.CODCOLIGADA
AND SS.CODSERVICO           = SP.CODSERVICO

INNER JOIN GFILIAL ON GFILIAL.CODCOLIGADA = SMP.CODCOLIGADA AND GFILIAL.CODFILIAL = SMP.CODFILIAL

WHERE
	SMP.CODCOLIGADA = 3
AND CONVERT(DATE,SP.DTVENCIMENTO) BETWEEN @DE AND @ATE

ORDER BY
	SP.PARCELA