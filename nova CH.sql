DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = '2018-01-02'
SET @DATAATE = '2018-28-02'

SELECT DISTINCT
	3 AS TIPOREG,
	NULL AS OPERACAO,
	TAB.CH_CODMATRICULA,
	TAB.CH_MESANO,
	SUM(TAB.CH_FESCOLAR) CH_FESCOLAR,
	SUM(TAB.CH_FESTAGIO) CH_FESTAGIO,
	SUM(TAB.CH_PRAPROFISSIONAL) CH_PRAPROFISSIONAL
FROM

(SELECT 
		DISTINCT
		LEFT(ISNULL(SHABILITACAOALUNOCOMPL.IDMATRICSI,CONCAT(SMATRICPL.RA,SMATRICPL.IDHABILITACAOFILIAL)),20) 
		AS  CH_CODMATRICULA, 
	   	CONVERT(VARCHAR,@DATADE,103) AS CH_MESANO,
	   	
	/*TRECHO PARA CAPTURAR O STATUS*/
	CASE
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL) > @DATAATE) THEN 
		
		   (SELECT SLG.CODSTATUS 
				FROM SLOGPLETIVO SLG 
				WHERE
					SLG.CODCOLIGADA 		= SMATRICPL.CODCOLIGADA 
				AND SLG.IDPERLET 			= SMATRICPL.IDPERLET 
				AND SLG.CODFILIAL 			= SMATRICPL.CODFILIAL 
				AND SLG.CODTURMA 			= SMATRICPL.CODTURMA 
				AND SLG.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
				AND SLG.RA 					= SMATRICPL.RA
				AND SLG.CODSTATUS 		   != 1 
				AND SLG.DTALTERACAO 		= (SELECT MAX(SLP.DTALTERACAO) 
												FROM SLOGPLETIVO SLP
									   			WHERE	
									   				SLP.CODCOLIGADA 				= SMATRICPL.CODCOLIGADA
									   			AND SLP.IDPERLET 					= SMATRICPL.IDPERLET 
												AND SLP.CODFILIAL					= SMATRICPL.CODFILIAL 
												AND SLP.CODTURMA 					= SMATRICPL.CODTURMA 
												AND SLP.IDHABILITACAOFILIAL 		= SMATRICPL.IDHABILITACAOFILIAL
												AND SLP.RA 							= SMATRICPL.RA
												AND CONVERT(DATE,SLP.DTALTERACAO) 	<= @DATAATE))
				
		ELSE SMATRICPL.CODSTATUS
	END	AS MAT_SITUACAO,
	   ISNULL((	SELECT 
				CONVERT(INT, SUM(V_SI_CHDISCIPLINA.HRDISC) - ISNULL(SUM(V_SI_FALTA_ALU_DISCIPLINA.FALTA),0)) AS CHESCOLAR
				FROM 
					V_SI_CHDISCIPLINA
				 
				INNER JOIN SMATRICULA (NOLOCK) ON 
							V_SI_CHDISCIPLINA.CODCOLIGADA = SMATRICULA.CODCOLIGADA AND 
							V_SI_CHDISCIPLINA.IDTURMADISC = SMATRICULA.IDTURMADISC AND
							(V_SI_CHDISCIPLINA.CODSUBTURMA = SMATRICULA.CODSUBTURMA OR SMATRICULA.CODSUBTURMA IS NULL) 
							
				LEFT OUTER JOIN V_SI_FALTA_ALU_DISCIPLINA ON 
							V_SI_CHDISCIPLINA.CODCOLIGADA = V_SI_FALTA_ALU_DISCIPLINA.CODCOLIGADA AND 
							V_SI_CHDISCIPLINA.CODTURMA = V_SI_FALTA_ALU_DISCIPLINA.CODTURMA AND 
							V_SI_CHDISCIPLINA.IDPERLET = V_SI_FALTA_ALU_DISCIPLINA.IDPERLET AND 
							V_SI_CHDISCIPLINA.IDTURMADISC = V_SI_FALTA_ALU_DISCIPLINA.IDTURMADISC AND 
							V_SI_CHDISCIPLINA.DATA = V_SI_FALTA_ALU_DISCIPLINA.DATA  AND
							V_SI_FALTA_ALU_DISCIPLINA.RA = SMATRICULA.RA AND
							V_SI_FALTA_ALU_DISCIPLINA.DATA >= @DATADE AND V_SI_FALTA_ALU_DISCIPLINA.DATA <= @DATAATE
				WHERE 
					SMATRICULA.RA = SMATRICPL.RA AND
					V_SI_CHDISCIPLINA.CODCOLIGADA =  SMATRICPL.CODCOLIGADA   AND
					V_SI_CHDISCIPLINA.CODTURMA = SMATRICPL.CODTURMA AND	
					V_SI_CHDISCIPLINA.IDPERLET = SMATRICPL.IDPERLET AND
					V_SI_CHDISCIPLINA.NOME NOT LIKE '%ESTAGIO%' AND
					V_SI_CHDISCIPLINA.NOME NOT LIKE '%PRATICA PROFISSIONAL%' 	AND	
					V_SI_CHDISCIPLINA.DATA >= @DATADE  AND V_SI_CHDISCIPLINA.DATA <= @DATAATE 
				)
		
		,0)	AS CH_FESCOLAR,
		ISNULL((SELECT		  
		  CONVERT(INT, SUM(V_SI_CHDISCIPLINA.HRDISC) - ISNULL(SUM(V_SI_FALTA_ALU_DISCIPLINA.FALTA),0)) AS CHESCOLAR
		
		FROM V_SI_CHDISCIPLINA 
		 
		INNER JOIN SMATRICULA (NOLOCK) ON 
					V_SI_CHDISCIPLINA.CODCOLIGADA = SMATRICULA.CODCOLIGADA AND 
					V_SI_CHDISCIPLINA.IDTURMADISC = SMATRICULA.IDTURMADISC AND
					(V_SI_CHDISCIPLINA.CODSUBTURMA = SMATRICULA.CODSUBTURMA OR SMATRICULA.CODSUBTURMA IS NULL)
					
		LEFT OUTER JOIN V_SI_FALTA_ALU_DISCIPLINA ON 
					V_SI_CHDISCIPLINA.CODCOLIGADA = V_SI_FALTA_ALU_DISCIPLINA.CODCOLIGADA AND 
					V_SI_CHDISCIPLINA.CODTURMA = V_SI_FALTA_ALU_DISCIPLINA.CODTURMA AND 
					V_SI_CHDISCIPLINA.IDPERLET = V_SI_FALTA_ALU_DISCIPLINA.IDPERLET AND 
					V_SI_CHDISCIPLINA.IDTURMADISC = V_SI_FALTA_ALU_DISCIPLINA.IDTURMADISC AND 
					V_SI_CHDISCIPLINA.DATA = V_SI_FALTA_ALU_DISCIPLINA.DATA  AND
					V_SI_FALTA_ALU_DISCIPLINA.RA = SMATRICULA.RA AND
					V_SI_FALTA_ALU_DISCIPLINA.DATA >= @DATADE  AND V_SI_FALTA_ALU_DISCIPLINA.DATA <= @DATAATE
		WHERE 
			SMATRICULA.RA = SMATRICPL.RA AND
			V_SI_CHDISCIPLINA.CODCOLIGADA =  SMATRICPL.CODCOLIGADA   AND
			V_SI_CHDISCIPLINA.CODTURMA = SMATRICPL.CODTURMA AND	
			V_SI_CHDISCIPLINA.IDPERLET = SMATRICPL.IDPERLET AND
			V_SI_CHDISCIPLINA.NOME LIKE '%ESTAGIO%' 		AND	
			V_SI_CHDISCIPLINA.DATA >= @DATADE  AND V_SI_CHDISCIPLINA.DATA <= @DATAATE ),0)
		AS CH_FESTAGIO,
		ISNULL(
		( 
		SELECT 
		  
		  CONVERT(INT, SUM(V_SI_CHDISCIPLINA.HRDISC) - ISNULL(SUM(V_SI_FALTA_ALU_DISCIPLINA.FALTA),0)) AS CHESCOLAR
		
		FROM V_SI_CHDISCIPLINA 
		 
		INNER JOIN SMATRICULA (NOLOCK) ON 
					V_SI_CHDISCIPLINA.CODCOLIGADA = SMATRICULA.CODCOLIGADA AND 
					V_SI_CHDISCIPLINA.IDTURMADISC = SMATRICULA.IDTURMADISC AND
					(V_SI_CHDISCIPLINA.CODSUBTURMA = SMATRICULA.CODSUBTURMA OR SMATRICULA.CODSUBTURMA IS NULL)
					
		LEFT OUTER JOIN V_SI_FALTA_ALU_DISCIPLINA ON 
					V_SI_CHDISCIPLINA.CODCOLIGADA = V_SI_FALTA_ALU_DISCIPLINA.CODCOLIGADA AND 
					V_SI_CHDISCIPLINA.CODTURMA = V_SI_FALTA_ALU_DISCIPLINA.CODTURMA AND 
					V_SI_CHDISCIPLINA.IDPERLET = V_SI_FALTA_ALU_DISCIPLINA.IDPERLET AND 
					V_SI_CHDISCIPLINA.IDTURMADISC = V_SI_FALTA_ALU_DISCIPLINA.IDTURMADISC AND 
					V_SI_CHDISCIPLINA.DATA = V_SI_FALTA_ALU_DISCIPLINA.DATA  AND
					V_SI_FALTA_ALU_DISCIPLINA.RA = SMATRICULA.RA AND
					V_SI_FALTA_ALU_DISCIPLINA.DATA >= @DATADE  AND V_SI_FALTA_ALU_DISCIPLINA.DATA <= @DATAATE
		WHERE 
			SHABILITACAOALUNOCOMPL.CONDALUNO = '1' AND
			SMATRICULA.RA = SMATRICPL.RA AND
			V_SI_CHDISCIPLINA.CODCOLIGADA =  SMATRICPL.CODCOLIGADA   AND
			V_SI_CHDISCIPLINA.CODTURMA = SMATRICPL.CODTURMA AND	
			V_SI_CHDISCIPLINA.IDPERLET = SMATRICPL.IDPERLET AND
			V_SI_CHDISCIPLINA.NOME LIKE '%PRATICA PROFISSIONAL%'	AND
			V_SI_CHDISCIPLINA.DATA >= @DATADE  AND V_SI_CHDISCIPLINA.DATA <= @DATAATE ),0)
		
		AS CH_PRAPROFISSIONAL
		
FROM SMATRICPL

INNER JOIN SHABILITACAOALUNO ON SHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SHABILITACAOALUNO.RA = SMATRICPL.RA
INNER JOIN SHABILITACAOALUNOCOMPL ON SHABILITACAOALUNOCOMPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL AND SHABILITACAOALUNOCOMPL.RA = SHABILITACAOALUNO.RA
INNER JOIN SMATRICPLCOMPL ON SMATRICPLCOMPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SMATRICPLCOMPL.IDPERLET = SMATRICPL.IDPERLET AND SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SMATRICPLCOMPL.RA = SMATRICPL.RA
LEFT  JOIN  SLOGPLETIVO (NOLOCK) ON 
			SLOGPLETIVO.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
		AND SLOGPLETIVO.IDPERLET = SMATRICPL.IDPERLET 
	    AND SLOGPLETIVO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
		AND SLOGPLETIVO.CODTURMA = SMATRICPL.CODTURMA 
		AND SLOGPLETIVO.RA = SMATRICPL.RA 
	    AND SLOGPLETIVO.DTALTERACAO = (SELECT MAX( ULTIMAALTERACAO.DTALTERACAO)
												FROM 
													SLOGPLETIVO (NOLOCK) ULTIMAALTERACAO
												 WHERE  
													 ULTIMAALTERACAO.CODCOLIGADA = SLOGPLETIVO.CODCOLIGADA
													 AND ULTIMAALTERACAO.CODFILIAL = SLOGPLETIVO.CODFILIAL 
													 AND ULTIMAALTERACAO.IDPERLET = SLOGPLETIVO.IDPERLET 
													 AND ULTIMAALTERACAO.IDHABILITACAOFILIAL = SLOGPLETIVO.IDHABILITACAOFILIAL 
													 AND ULTIMAALTERACAO.RA = SLOGPLETIVO.RA 
													 AND ULTIMAALTERACAO.CODTURMA = SLOGPLETIVO.CODTURMA 
													 AND ULTIMAALTERACAO.OPERACAO NOT IN ('I','E')								 
											   )
INNER JOIN STURMA ON STURMA.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND STURMA.CODFILIAL = SMATRICPL.CODFILIAL AND STURMA.CODTURMA = SMATRICPL.CODTURMA AND STURMA.IDPERLET = SMATRICPL.IDPERLET
INNER JOIN STURMACOMPL ON STURMACOMPL.CODCOLIGADA = STURMA.CODCOLIGADA AND STURMACOMPL.CODFILIAL = STURMA.CODFILIAL AND STURMACOMPL.CODTURMA = STURMA.CODTURMA AND STURMACOMPL.IDPERLET = STURMA.IDPERLET
INNER JOIN SSTATUS ON SSTATUS.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SSTATUS.CODSTATUS = SMATRICPL.CODSTATUS

WHERE 

SMATRICPL.CODCOLIGADA = 3
AND STURMA.DTFINAL >= @DATADE AND STURMA.DTINICIAL <= @DATAATE 
AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
AND ((CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) >= @DATADE)OR (SMATRICPL.CODSTATUS = '2'))
AND STURMACOMPL.TIPOTURMA NOT IN ('11','12')
AND SMATRICPL.CODSTATUS != 1

) AS TAB

WHERE TAB.MAT_SITUACAO IS NOT NULL

GROUP BY 
TAB.CH_CODMATRICULA,
TAB.CH_MESANO