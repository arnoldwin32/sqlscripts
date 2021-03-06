DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = '2018-01-02'
SET @DATAATE = '2018-28-02'

SELECT
	DISTINCT
	3 AS TIPOREG,
	NULL AS OPERACAO,
	CARGAHORARIA.CH_CODMATRICULA,
	--CARGAHORARIA.MAT_SITUACAO,
	CARGAHORARIA.CH_MESANO,
	SUM(CARGAHORARIA.CH_FESCOLAR) CH_FESCOLAR
	--SUM(CARGAHORARIA.CH_FESTAGIO) CH_FESTAGIO,
	--SUM(CARGAHORARIA.CH_PRAPROFISSIONAL) CH_PRAPROFISSIONAL
FROM
(

	SELECT 
		DISTINCT
		LEFT(ISNULL(SHABILITACAOALUNOCOMPL.IDMATRICSI,CONCAT(SMATRICPL.RA,SMATRICPL.IDHABILITACAOFILIAL)),20) 
		--SMATRICPL.RA
		AS  CH_CODMATRICULA, 
	   /*	CASE
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
	END	AS MAT_SITUACAO,*/
		   
		CONVERT(VARCHAR,@DATADE,103) AS CH_MESANO,
	   ISNULL(
			( 
				SELECT 
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
		
		,0)	AS CH_FESCOLAR/*,
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
		
		AS CH_PRAPROFISSIONAL*/
	
	FROM   
		STURMA (NOLOCK)
		
		JOIN STURMACOMPL (NOLOCK) 
			ON STURMACOMPL.CODCOLIGADA = STURMA.CODCOLIGADA 
			AND STURMACOMPL.CODFILIAL = STURMA.CODFILIAL 
			AND STURMACOMPL.CODTURMA = STURMA.CODTURMA 
			AND STURMACOMPL.IDPERLET = STURMA.IDPERLET
			
		
		JOIN SHABILITACAOFILIAL (NOLOCK) 
			ON SHABILITACAOFILIAL.CODCOLIGADA = STURMA.CODCOLIGADA 
			AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = STURMA.IDHABILITACAOFILIAL
			AND SHABILITACAOFILIAL.CODFILIAL = STURMA.CODFILIAL
			
		 JOIN SMATRICPL (NOLOCK)
		 	ON SMATRICPL.CODCOLIGADA = STURMA.CODCOLIGADA 
		 	--AND SMATRICPL.IDHABILITACAOFILIAL = STURMA.IDHABILITACAOFILIAL 
		 	--AND SMATRICPL.RA = STURMA.RA
		 	AND SMATRICPL.CODFILIAL = STURMA.CODFILIAL
		 	AND SMATRICPL.IDPERLET = STURMA.IDPERLET
		
			JOIN SMATRICPLCOMPL (NOLOCK) 
			ON SMATRICPLCOMPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
			AND SMATRICPLCOMPL.IDPERLET = SMATRICPL.IDPERLET 
			AND SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
			AND SMATRICPLCOMPL.RA = SMATRICPL.RA
		
		JOIN SHABILITACAOALUNO 
			ON SHABILITACAOALUNO.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
			AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
			AND SHABILITACAOALUNO.RA = SMATRICPL.RA
			
				JOIN SHABILITACAOALUNOCOMPL (NOLOCK)
			ON SHABILITACAOALUNOCOMPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
			AND SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL 
			AND SHABILITACAOALUNOCOMPL.RA = SHABILITACAOALUNO.RA
		
			
		JOIN SCURSO (NOLOCK) 
			ON SCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA 
			AND SCURSO.CODCURSO=SHABILITACAOFILIAL.CODCURSO
		
		JOIN SGRADE (NOLOCK) 
			ON SGRADE.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA 
			AND SGRADE.CODCURSO = SHABILITACAOFILIAL.CODCURSO 
			AND SGRADE.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO 
			AND SGRADE.CODGRADE = SHABILITACAOFILIAL.CODGRADE
		
		JOIN SHABILITACAO (NOLOCK) 
			ON SHABILITACAO.CODCOLIGADA = SCURSO.CODCOLIGADA 
			AND SHABILITACAO.CODCURSO = SCURSO.CODCURSO
		
		JOIN SGRADECOMPL (NOLOCK) 
			ON SGRADECOMPL.CODCOLIGADA = SGRADE.CODCOLIGADA 
			AND SGRADECOMPL.CODCURSO = SGRADE.CODCURSO 
			AND SGRADECOMPL.CODHABILITACAO = SGRADE.CODHABILITACAO 
			AND SGRADECOMPL.CODGRADE = SGRADE.CODGRADE
		
		JOIN SCURSOCOMPL(NOLOCK) 
			ON SCURSO.CODCOLIGADA = SCURSOCOMPL.CODCOLIGADA 
			AND SCURSO.CODCURSO = SCURSOCOMPL.CODCURSO
				JOIN SSTATUS (NOLOCK) 
			ON SSTATUS.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
			AND SSTATUS.CODSTATUS = SHABILITACAOALUNO.CODSTATUS	
			
		LEFT JOIN SCONTRATO (NOLOCK) 
			ON SCONTRATO.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
			AND SCONTRATO.RA = SMATRICPL.RA 
			AND SCONTRATO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
			AND SCONTRATO.IDPERLET = SMATRICPL.IDPERLET
		
	   /* LEFT JOIN SLOGPLETIVO ON 
			SLOGPLETIVO.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
		AND SLOGPLETIVO.IDPERLET = SMATRICPL.IDPERLET 
	    AND SLOGPLETIVO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
		AND SLOGPLETIVO.CODTURMA = SMATRICPL.CODTURMA 
		AND SLOGPLETIVO.CODFILIAL = SMATRICPL.CODFILIAL
		AND SLOGPLETIVO.RA = SMATRICPL.RA 
	    AND SLOGPLETIVO.DTALTERACAO = (SELECT MAX( ULTIMAALTERACAO.DTALTERACAO)
												FROM 
													SLOGPLETIVO ULTIMAALTERACAO
												 WHERE  
													 ULTIMAALTERACAO.CODCOLIGADA = SLOGPLETIVO.CODCOLIGADA
													 AND ULTIMAALTERACAO.CODFILIAL = SLOGPLETIVO.CODFILIAL 
													 AND ULTIMAALTERACAO.IDPERLET = SLOGPLETIVO.IDPERLET 
													 AND ULTIMAALTERACAO.IDHABILITACAOFILIAL = SLOGPLETIVO.IDHABILITACAOFILIAL 
													 AND ULTIMAALTERACAO.RA = SLOGPLETIVO.RA 
													 AND ULTIMAALTERACAO.CODTURMA = SLOGPLETIVO.CODTURMA 
													 AND ULTIMAALTERACAO.OPERACAO NOT IN ('I','E')								 
											   )*/
		
	WHERE  
	   	SCURSO.CODCOLIGADA = 3 
		AND STURMA.DTFINAL >= @DATADE 
		AND STURMA.DTINICIAL <= @DATAATE 
		AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
		--AND ((CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) >= @DATADE)OR (SMATRICPL.CODSTATUS = '2'))
		AND STURMACOMPL.TIPOTURMA NOT IN ('11','12')
		AND SMATRICPL.CODSTATUS !	= 1
 		AND SMATRICPL.CODFILIAL 	= 4
 		AND SMATRICPL.RA = '0037336'

) AS CARGAHORARIA
--WHERE CARGAHORARIA.CH_CODMATRICULA = '0036567'
GROUP BY CARGAHORARIA.CH_CODMATRICULA,CARGAHORARIA.CH_MESANO,CARGAHORARIA.CH_FESCOLAR