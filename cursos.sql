DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = :DATADE_D
SET @DATAATE = :DATAATE_D

SELECT DISTINCT

1 AS TIPOREG,
NULL AS OPERACAO,
CURSOS.CODCURSO,
CURSOS.NOME_CURSO,
CURSOS.LINHA_ACAO,
CURSOS.MODALIDADE,
CURSOS.AREA,
CURSOS.EIXO,
CURSOS.CURSO_MEC,
CURSOS.NIVEL_MEC,
CURSOS.CBO,
CURSOS.CHESCOLAR,
CURSOS.CHESTAGIO,
CURSOS.DTINICIO,
CURSOS.DTFIM,
CURSOS.C1,
CURSOS.C2,
CURSOS.C3,
CURSOS.C4,
CURSOS.C5,
CURSOS.C6

FROM (
SELECT 
	DISTINCT
	ISNULL(SI_CURSOS.CODCURSO,ISNULL(SICURSOS.CODCURSO,ISNULL(SGRADECOMPL.CURSOSCOP, ISNULL(SGRADECOMPL.IDSOLUCAOINTEGRADORA,SGRADE.CODGRADE)))) CODCURSO,
	ISNULL(SI_CURSOS.NOME_CURSO,ISNULL(SICURSOS.NOME_CURSO,ISNULL(SCURSO.COMPLEMENTO,SCURSO.NOME))) NOME_CURSO,
	ISNULL(SI_CURSOS.LINHA_ACAO,ISNULL(SICURSOS.LINHA_ACAO,SCURSOCOMPL.LINHAACAO)) LINHA_ACAO,
	ISNULL(SI_CURSOS.MODALIDADE,ISNULL(SICURSOS.MODALIDADE,SCURSO.CODMODALIDADECURSO)) MODALIDADE,
	ISNULL(SI_CURSOS.AREA,ISNULL(SICURSOS.AREA,SCURSO.CODAREA)) AREA,
	ISNULL(SI_CURSOS.EIXO,ISNULL(SICURSOS.EIXO,ISNULL(SCURSO.IDEIXOTECNOLOGICO,0))) EIXO,
	ISNULL(SI_CURSOS.CURSO_MEC,ISNULL(SICURSOS.CURSO_MEC,SCURSOCOMPL.CURSOMEC)) CURSO_MEC,
	ISNULL(SI_CURSOS.NIVEL_MEC,ISNULL(SICURSOS.NIVEL_MEC,SCURSOCOMPL.NIVELMEC)) NIVEL_MEC,
	ISNULL(SI_CURSOS.CBO,ISNULL(SICURSOS.CBO,SUBSTRING(ISNULL(SCURSOCOMPL.OCUPACAO,0),0,7))) CBO,
	ISNULL(SI_CURSOS.CHESCOLAR,ISNULL(SICURSOS.CHESCOLAR,SGRADECOMPL.CHESCOLAR)) CHESCOLAR,
	ISNULL(SI_CURSOS.CHESTAGIO,ISNULL(SICURSOS.CHESTAGIO,SGRADECOMPL.CHESTAGIO)) CHESTAGIO,
	ISNULL(SI_CURSOS.DTINICIO,ISNULL(SICURSOS.DTINICIO,CONVERT(VARCHAR(10),SGRADE.DTINICIO,103))) DTINICIO,
	CASE 
		WHEN (SI_CURSOS.DTFIM IS NOT NULL AND SI_CURSOS.DTFIM != '')  THEN SI_CURSOS.DTFIM
		WHEN (SICURSOS.DTFIM IS NOT NULL AND SICURSOS.DTFIM != '')  THEN SICURSOS.DTFIM
		WHEN (SGRADE.DTFIM IS NOT NULL AND SGRADE.DTFIM != '') AND SGRADE.DTFIM < @DATADE THEN NULL
		ELSE CONVERT(VARCHAR(10),SGRADE.DTFIM,103) 
	END DTFIM,
	0 C1,
	0 C2,
	0 C3,
	0 C4,
	0 C5,
	0 C6,
	
   	/*TRECHO PARA CAPTURAR O STATUS*/
		CASE
			WHEN 
			(CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND 
			CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL) > @DATAATE) AND 
			SMODALIDADECURSO.CODMODALIDADECURSO NOT IN (15,31)
			THEN 2 
			ELSE
		SHABILITACAOALUNO.CODSTATUS
   		END	
	AS MAT_SITUACAO
	
FROM   

SMATRICPL (NOLOCK)

INNER JOIN SHABILITACAOALUNO (NOLOCK) ON 
	SHABILITACAOALUNO.CODCOLIGADA 			= SMATRICPL.CODCOLIGADA AND 
	SHABILITACAOALUNO.IDHABILITACAOFILIAL 	= SMATRICPL.IDHABILITACAOFILIAL AND 
	SHABILITACAOALUNO.RA 					= SMATRICPL.RA

INNER JOIN SHABILITACAOALUNOCOMPL (NOLOCK) ON 
	SHABILITACAOALUNOCOMPL.CODCOLIGADA 			= SHABILITACAOALUNO.CODCOLIGADA AND 
	SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL 	= SHABILITACAOALUNO.IDHABILITACAOFILIAL AND 
	SHABILITACAOALUNOCOMPL.RA 					= SHABILITACAOALUNO.RA

INNER JOIN SMATRICPLCOMPL (NOLOCK) ON 
	SMATRICPLCOMPL.CODCOLIGADA 			= SMATRICPL.CODCOLIGADA AND 
	SMATRICPLCOMPL.IDPERLET 			= SMATRICPL.IDPERLET AND 
	SMATRICPLCOMPL.IDHABILITACAOFILIAL 	= SMATRICPL.IDHABILITACAOFILIAL AND 
	SMATRICPLCOMPL.RA 					= SMATRICPL.RA

LEFT  JOIN SLOGPLETIVO (NOLOCK) ON 
			SLOGPLETIVO.CODCOLIGADA 		= SMATRICPL.CODCOLIGADA 
		AND SLOGPLETIVO.IDPERLET 			= SMATRICPL.IDPERLET 
	    AND SLOGPLETIVO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
		AND SLOGPLETIVO.CODTURMA 			= SMATRICPL.CODTURMA 
		AND SLOGPLETIVO.RA 					= SMATRICPL.RA 
	    AND SLOGPLETIVO.DTALTERACAO 		= (SELECT MAX( ULTIMAALTERACAO.DTALTERACAO)
												FROM 
													SLOGPLETIVO (NOLOCK) ULTIMAALTERACAO
												 WHERE  
													 ULTIMAALTERACAO.CODCOLIGADA 				= SLOGPLETIVO.CODCOLIGADA
													 AND ULTIMAALTERACAO.CODFILIAL 				= SLOGPLETIVO.CODFILIAL 
													 AND ULTIMAALTERACAO.IDPERLET 				= SLOGPLETIVO.IDPERLET 
													 AND ULTIMAALTERACAO.IDHABILITACAOFILIAL 	= SLOGPLETIVO.IDHABILITACAOFILIAL 
													 AND ULTIMAALTERACAO.RA 					= SLOGPLETIVO.RA 
													 AND ULTIMAALTERACAO.CODTURMA 				= SLOGPLETIVO.CODTURMA 
													 AND ULTIMAALTERACAO.OPERACAO 				NOT IN ('I','E'))
INNER JOIN STURMA (NOLOCK) ON 
	STURMA.CODCOLIGADA 	= SMATRICPL.CODCOLIGADA AND 
	STURMA.CODFILIAL 	= SMATRICPL.CODFILIAL AND 
	STURMA.CODTURMA 	= SMATRICPL.CODTURMA AND 
	STURMA.IDPERLET 	= SMATRICPL.IDPERLET


INNER JOIN STURMACOMPL (NOLOCK) ON 
	STURMACOMPL.CODCOLIGADA = STURMA.CODCOLIGADA AND 
	STURMACOMPL.CODFILIAL 	= STURMA.CODFILIAL AND 
	STURMACOMPL.CODTURMA 	= STURMA.CODTURMA AND 
	STURMACOMPL.IDPERLET 	= STURMA.IDPERLET


INNER JOIN SHABILITACAOFILIAL (NOLOCK) ON 
	SHABILITACAOFILIAL.CODCOLIGADA 			= SHABILITACAOALUNO.CODCOLIGADA AND 
	SHABILITACAOFILIAL.IDHABILITACAOFILIAL 	= SHABILITACAOALUNO.IDHABILITACAOFILIAL


INNER JOIN SGRADE (NOLOCK) ON 
	SGRADE.CODCOLIGADA 		= SHABILITACAOFILIAL.CODCOLIGADA AND 
	SGRADE.CODCURSO 		= SHABILITACAOFILIAL.CODCURSO AND 
	SGRADE.CODHABILITACAO 	= SHABILITACAOFILIAL.CODHABILITACAO AND 
	SGRADE.CODGRADE 		= SHABILITACAOFILIAL.CODGRADE


INNER JOIN SGRADECOMPL (NOLOCK) ON 
	SGRADECOMPL.CODCOLIGADA 	= SGRADE.CODCOLIGADA AND 
	SGRADECOMPL.CODCURSO 		= SGRADE.CODCURSO AND 
	SGRADECOMPL.CODHABILITACAO 	= SGRADE.CODHABILITACAO AND 
	SGRADECOMPL.CODGRADE 		= SGRADE.CODGRADE


INNER JOIN SHABILITACAO (NOLOCK) ON 
	SHABILITACAO.CODCOLIGADA 	= SGRADE.CODCOLIGADA AND 
	SHABILITACAO.CODCURSO 		= SGRADE.CODCURSO AND 
	SHABILITACAO.CODHABILITACAO = SGRADE.CODHABILITACAO


INNER JOIN SCURSO (NOLOCK) ON 
	SCURSO.CODCOLIGADA 	= SHABILITACAO.CODCOLIGADA AND 
	SCURSO.CODCURSO 	= SHABILITACAO.CODCURSO


INNER JOIN SMODALIDADECURSO (NOLOCK) ON 
	SMODALIDADECURSO.CODCOLIGADA 		= SCURSO.CODCOLIGADA AND 
	SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO


INNER JOIN SCURSOCOMPL (NOLOCK) ON 
	SCURSOCOMPL.CODCOLIGADA = SCURSO.CODCOLIGADA AND 
	SCURSOCOMPL.CODCURSO 	= SCURSO.CODCURSO


INNER JOIN SSTATUS (NOLOCK) ON 
	SSTATUS.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND 
	SSTATUS.CODSTATUS 	= SMATRICPL.CODSTATUS


LEFT  JOIN SI_CURSOS (NOLOCK) ON 
	SHABILITACAOALUNOCOMPL.CODCURSO = SI_CURSOS.CODCURSO


LEFT  JOIN SI_CURSOS SICURSOS (NOLOCK) ON 
	SGRADECOMPL.CURSOSCOP = SICURSOS.CODCURSO

WHERE  
	SCURSO.CODCOLIGADA = 3  
	AND STURMA.DTFINAL >= @DATADE AND STURMA.DTINICIAL <= @DATAATE
	AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
	AND ((CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) >= @DATADE)OR (SMATRICPL.CODSTATUS = '2'))
	AND STURMACOMPL.TIPOTURMA NOT IN ('11','12')
	AND SMATRICPL.CODSTATUS != 1
	
) CURSOS
WHERE CURSOS.MAT_SITUACAO IS NOT NULL
  