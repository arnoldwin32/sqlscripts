DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = '2018-01-04'
SET @DATAATE = '2018-30-04'

SELECT 
DISTINCT

TAB.MAT_CODMATRICULA,
TAB.MAT_UNIDADEATEND,
TAB.MAT_MODALIDADE,
TAB.MAT_CODCURSO,
TAB.MAT_CODTURMA,
TAB.MAT_ACAO,
TAB.MAT_LINHAACAO,
TAB.MAT_DATAENTRMATRICULA,
TAB.DTINICIOTURMA,
TAB.MAT_DATAPREVTERMI,
TAB.DTFIMTURMA,
CASE 
WHEN (TAB.MAT_SITUACAO != 2 AND CONVERT(DATE,TAB.MAT_DATAREALTERM) >= @DATAATE) THEN CONVERT(VARCHAR,@DATAATE,103)
WHEN (TAB.MAT_SITUACAO != 2 AND CONVERT(DATE,TAB.MAT_DATAREALTERM) < @DATAATE) THEN CONVERT(VARCHAR,TAB.MAT_DATAREALTERM,103)
ELSE NULL 
END AS 'DT_SAIDA',
TAB.MAT_MUNEXECUCAO,
TAB.MAT_CODALUNO,
CASE
   WHEN TAB.MAT_SITUACAO IN ('2','9','11','12','18') THEN 'Em Andamento'
   WHEN TAB.MAT_SITUACAO IN ('10','16') THEN 'Conclu�da'
   WHEN TAB.MAT_SITUACAO = 5 THEN 'Evadida'
   WHEN TAB.MAT_SITUACAO IN ('4','8','17') THEN 'Transferida - Interno'
   WHEN TAB.MAT_SITUACAO = 7 THEN 'Trancada'
   WHEN TAB.MAT_SITUACAO  = 15 THEN 'Pendente de Est�gio'
   WHEN TAB.MAT_SITUACAO  IN (3,6,47) THEN 'Aluno Desistente'
   WHEN TAB.MAT_SITUACAO = 46 THEN 'Aluno Falecido'
   WHEN TAB.MAT_SITUACAO IN ('13','20') THEN 'Aluno Reprovado'
   WHEN TAB.MAT_SITUACAO = 48 THEN 'Transferida - Externa'
   ELSE NULL
END AS 'SITUACAO',
TAB.MAT_TIPOENTRADA,
TAB.MAT_CONDALU,
TAB.MAT_ARTICULACAO,
TAB.MAT_TIPOGRAT,
TAB.MAT_TIPOESCOLA,
TAB.MAT_INDPRONATEC,
TAB.MAT_DATAINIVIGENCIA,
TAB.MAT_DATAFIMVIGENCIA,
TAB.MAT_PRATICAPROFISSIONAL,
TAB.CH_MES,
TAB.MAT_TURNO,
TAB.MAT_HORARIO,
TAB.MAT_PERIODO,
TAB.MAT_CNPJEMPRESAATEND,
TAB.MAT_MOTIVOCPF,
TAB.MAT_CPF,
TAB.MAT_NOMEALUNO,
TAB.MAT_DTNASCIMENTO,
TAB.MAT_NOMEMAE,
TAB.MAT_RESPONSAVEL,
TAB.MAT_NOMEPAI,
TAB.MAT_IDENTIDADE,
TAB.MAT_ORGEMISSOR,
TAB.MAT_DTEMISSAO,
TAB.MAT_PISPASEP,
TAB.MAT_SEXO,
TAB.MAT_CORRACA,
TAB.MAT_CODPAIS,
TAB.MAT_NATURALIDADE,
TAB.MAT_ESTADOCIVIL,
TAB.MAT_GRAUINSTRUCAO,
TAB.MAT_SITOCUP,
TAB.MAT_NECESSIDADESPECIAIS,
TAB.MAT_RUA,
TAB.MAT_NUMERO,
TAB.MAT_COMPLEMENTO,
TAB.MAT_BAIRRO,
TAB.MAT_CIDADE,
TAB.MAT_ESTADO,
TAB.MAT_CEP,
TAB.MAT_DDD,
TAB.MAT_TELEFONE,
TAB.MAT_DDDCELULAR,
TAB.MAT_CELULAR,
TAB.MAT_EMAIL,
TAB.MAT_PESSOAFISOUJUR,
TAB.RESPF_CNPJ,
TAB.RESPF_CPF,
TAB.RESPJ_NOME,
TAB.RESPF_NOME,
TAB.RESPF_RUA,
TAB.RESPF_NUMERO,
TAB.RESPF_COMPLEMENTO,
TAB.RESPF_BAIRRO,
TAB.RESPF_MUNICIPIO,
TAB.RESPF_ESTADO,
TAB.RESPF_CEP,
TAB.RESPF_TELEFONE,
TAB.RESPF_FAX,
TAB.RESPF_EMAIL,
TAB.RESPF_CONTATO

FROM

(SELECT 
   	LEFT(ISNULL(SHABILITACAOALUNOCOMPL.IDMATRICSI,(CONCAT(SMATRICPL.RA,SMATRICPL.IDHABILITACAOFILIAL))),20) AS  MAT_CODMATRICULA,
	GFILIAL.NOMEFANTASIA 		AS MAT_UNIDADEATEND,
	SMODALIDADECURSO.DESCRICAO 	AS MAT_MODALIDADE,
	SCURSO.NOME 				AS MAT_CODCURSO,
	STURMA.CODTURMA  			AS MAT_CODTURMA,
	CASE 
		WHEN 
		SCURSO.CURPRESDIST = 'D' THEN '� Dist�ncia' 
		ELSE 'Presencial' END 	AS MAT_ACAO,
	LINHAACAO.DESCRICAO 		AS MAT_LINHAACAO,
	CASE 
		WHEN SHABILITACAOALUNOCOMPL.DATAINICIAL IS NOT NULL THEN CONVERT(VARCHAR,SHABILITACAOALUNOCOMPL.DATAINICIAL,103)
		WHEN ((SMATRICPL.DTMATRICULA < STURMA.DTINICIAL) OR (STURMA.DTINICIAL = STURMA.DTFINAL)) THEN CONVERT(VARCHAR,STURMA.DTINICIAL,103)
		ELSE CONVERT(VARCHAR,SMATRICPL.DTMATRICULA,103)
	END MAT_DATAENTRMATRICULA,
	CONVERT(DATE,STURMA.DTINICIAL) AS 'DTINICIOTURMA',
	
	CASE
		WHEN SHABILITACAOALUNOCOMPL.DATAFINAL IS NOT NULL THEN CONVERT(VARCHAR,SHABILITACAOALUNOCOMPL.DATAFINAL,103)
		ELSE CONVERT(VARCHAR,STURMA.DTFINAL,103)
	END AS MAT_DATAPREVTERMI,
	CONVERT(DATE,STURMA.DTFINAL) AS 'DTFIMTURMA',
	
		CASE
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND CONVERT(DATE,STURMA.DTFINAL) < @DATAATE) THEN CONVERT(DATE,STURMA.DTFINAL)
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) < @DATAATE AND CONVERT(DATE,STURMA.DTFINAL) < @DATAATE) THEN CONVERT(DATE,STURMA.DTFINAL)
		ELSE CONVERT(DATE,SLOGPLETIVO.DTALTERACAO)
		END AS MAT_DATAREALTERM,
		
	GMUNICIPIO.NOMEMUNICIPIO AS MAT_MUNEXECUCAO,
	SALUNO.RA AS  MAT_CODALUNO,
	
	/*TRECHO PARA CAPTURAR O STATUS*/
   CASE
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL) > @DATAATE) THEN 
		
		   (SELECT DISTINCT SLG.CODSTATUS 
				FROM SLOGPLETIVO SLG (NOLOCK) 
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
	END	  AS MAT_SITUACAO,
	
	CASE 
		WHEN SMATRICPL.CODTIPOMAT IN ('1','2') THEN 'Nova'
		WHEN SMATRICPL.CODTIPOMAT = '5' THEN 		'Por transfer�ncia'
		WHEN SMATRICPL.CODTIPOMAT = '6' THEN 		'Por destrancamento'
	END AS MAT_TIPOENTRADA,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '1' THEN 'Contratado'
		 WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '2' THEN 'N�o Contratado'
		 WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '3' THEN 'N�o se aplica'
	END AS MAT_CONDALU,
	CASE WHEN SHABILITACAOALUNOCOMPL.ARTICULACAO = '1' THEN 'Sim' ELSE 'N�o' END AS MAT_ARTICULACAO,
	TIPOGRAT.DESCRICAO AS MAT_TIPOGRAT,
	CASE WHEN SALUNOCOMPL.TIPOESCOLA = '1' THEN 'Particular'
		 WHEN SALUNOCOMPL.TIPOESCOLA = '2' THEN 'P�blica Municipal'
		 WHEN SALUNOCOMPL.TIPOESCOLA = '3' THEN 'P�blica Estadual'
		 WHEN SALUNOCOMPL.TIPOESCOLA = '4' THEN 'P�blica Federal'
	ELSE 'N�o Declarado'
	END AS  MAT_TIPOESCOLA,
	INDICADOR.DESCRICAO AS  MAT_INDPRONATEC,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '1' AND SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') THEN CONVERT(VARCHAR(10),CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAINICIAL),103) ELSE NULL
	     END AS MAT_DATAINIVIGENCIA,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '1' AND SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') THEN CONVERT(VARCHAR(10),CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL),103) ELSE NULL
	     END AS MAT_DATAFIMVIGENCIA,
	ISNULL(SGRADECOMPL.CHPPC,0) AS MAT_PRATICAPROFISSIONAL,
	
	
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
		
		,0)	AS CH_MES,
	
	CASE WHEN STURNO.TIPO = 'I' THEN 'Integral'
		 WHEN STURNO.TIPO = 'M' THEN 'Matutino'
		 WHEN STURNO.TIPO = 'N' THEN 'Noturno'
		 WHEN STURNO.TIPO = 'V' THEN 'Vespertino'
		 ELSE NULL
	END AS MAT_TURNO, 
	CONCAT(STURNO.HORINI,' �s ',STURNO.HORFIM) AS MAT_HORARIO,
	SMATRICPL.PERIODO AS MAT_PERIODO,
	CASE WHEN LEN(EMPRESARESP.CGCCFO) <= 14 THEN ''
		ELSE
		CASE WHEN SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') AND SHABILITACAOALUNOCOMPL.CONDALUNO = '1' THEN EMPRESARESP.CGCCFO
		     ELSE '' END
	END AS MAT_CNPJEMPRESAATEND,
	0 AS MAT_MOTIVOCPF,
	REPLACE(REPLACE(REPLACE(PPESSOA.CPF,'-',''),'.',''),'/','') MAT_CPF,
	LEFT(PPESSOA.NOME,80) MAT_NOMEALUNO, 
	CONVERT(VARCHAR(10),PPESSOA.DTNASCIMENTO,103) MAT_DTNASCIMENTO, 
	LTRIM(RTRIM(REPLACE(REPLACE(  LEFT(CASE WHEN (CONVERT(VARCHAR(80),SALUNOCOMPL.MAE) LIKE '%DESCONHECID%' OR CONVERT(VARCHAR(80),SALUNOCOMPL.MAE) IS NULL) THEN 'DESCONHECIDA' ELSE CONVERT(VARCHAR(80),SALUNOCOMPL.MAE) END,80),CHAR(13),''),CHAR(10),'')  )) MAT_NOMEMAE,
	'' MAT_RESPONSAVEL,
	LTRIM(RTRIM(REPLACE(REPLACE(  SUBSTRING(SALUNOCOMPL.PAI,0,80),CHAR(13),''),CHAR(10),''))) MAT_NOMEPAI,
	CASE WHEN PPESSOA.CARTIDENTIDADE IS NOT NULL  AND PPESSOA.ORGEMISSORIDENT IS NOT NULL THEN SUBSTRING(REPLACE(REPLACE(REPLACE(PPESSOA.CARTIDENTIDADE,'-',''),'.',''),'/',''),0,15) 
	ELSE NULL END AS  MAT_IDENTIDADE,
	CASE WHEN PPESSOA.CARTIDENTIDADE IS NOT NULL  AND PPESSOA.ORGEMISSORIDENT IS NOT NULL AND PPESSOA.ORGEMISSORIDENT LIKE 'SSP%'THEN 'SSP'
	     WHEN PPESSOA.CARTIDENTIDADE IS NOT NULL  AND PPESSOA.ORGEMISSORIDENT IS NOT NULL THEN SUBSTRING(PPESSOA.ORGEMISSORIDENT,0,10)
	     ELSE NULL END AS MAT_ORGEMISSOR,
	CASE WHEN PPESSOA.CARTIDENTIDADE IS NOT NULL  AND PPESSOA.ORGEMISSORIDENT IS NOT NULL AND PPESSOA.DTEMISSAOIDENT IS NOT NULL AND  PPESSOA.DTEMISSAOIDENT<>'1900-01-01 00:00:00.000' THEN CONVERT(VARCHAR(10),PPESSOA.DTEMISSAOIDENT,103)
	     ELSE NULL END AS MAT_DTEMISSAO,
	REPLACE(REPLACE(REPLACE(SALUNOCOMPL.PISPASEP,'-',''),'.',''),'/','') MAT_PISPASEP,
	CASE WHEN PPESSOA.SEXO = 'F' THEN 'Feminino'
	     WHEN PPESSOA.SEXO = 'M' THEN 'Masculino'
	     ELSE NULL
	END AS MAT_SEXO,
	CASE WHEN PPESSOA.CORRACA = 2  THEN 'BRANCA'
	     WHEN PPESSOA.CORRACA = 4  THEN 'PRETA'
	     WHEN PPESSOA.CORRACA = 8  THEN 'PARDA'
	     WHEN PPESSOA.CORRACA = 6  THEN 'AMARELA'
	     WHEN PPESSOA.CORRACA = 0  THEN 'INDIGENA'
	ELSE 'NAO DECLARADO' END MAT_CORRACA,
	CASE WHEN PPESSOA.NACIONALIDADE = '10'  THEN 'BR' ELSE '' END MAT_CODPAIS, /* PENDENTE */
	ISNULL((SELECT 
	    TOP 1 DCODIFICACAOMUNICIPIO.CODIGO
	 FROM 
		GMUNICIPIO
		INNER JOIN DCODIFICACAOMUNICIPIO ON DCODIFICACAOMUNICIPIO.CODMUNICIPIO = GMUNICIPIO.CODMUNICIPIO AND DCODIFICACAOMUNICIPIO.CODETDMUNICIPIO = GMUNICIPIO.CODETDMUNICIPIO
	 WHERE
	 	GMUNICIPIO.CODETDMUNICIPIO = PPESSOA.ESTADONATAL
	 	AND GMUNICIPIO.NOMEMUNICIPIO = PPESSOA.NATURALIDADE
	),0) AS MAT_NATURALIDADE,
	CASE PPESSOA.ESTADOCIVIL 
	     WHEN 'C' THEN '2'  /* Casado */
	     WHEN 'D' THEN '3'  /* Desquitado */
	     WHEN 'I' THEN '4'  /* Divorciado */
	     WHEN 'S' THEN '1'  /* Solteiro */
	     WHEN 'V' THEN '5'  /* Vi�vo */
	     ELSE '6'
	END MAT_ESTADOCIVIL,
	CASE WHEN PPESSOA.GRAUINSTRUCAO IN ('2','3','4') THEN '1'
	     WHEN PPESSOA.GRAUINSTRUCAO = '5'     THEN '2'
	     WHEN PPESSOA.GRAUINSTRUCAO = '6'     THEN '3'
	     WHEN PPESSOA.GRAUINSTRUCAO = '7'     THEN '4'
	     WHEN PPESSOA.GRAUINSTRUCAO = '8'     THEN '5'
	     WHEN PPESSOA.GRAUINSTRUCAO IN ('9','A','B','C','D','E','F','G','H') THEN '6'
	END MAT_GRAUINSTRUCAO,
	ISNULL(SALUNOCOMPL.SITUACAOOCUP,'2') MAT_SITOCUP, /* TIRAR AP�S ACERTO DA UNIDADE*/
	CASE WHEN ISNULL(PPESSOA.DEFICIENTEMENTAL,0) +   ISNULL(PPESSOA.DEFICIENTEVISUAL,0) + ISNULL(PPESSOA.DEFICIENTEAUDITIVO,0) + ISNULL(PPESSOA.DEFICIENTEFISICO,0) + ISNULL(PPESSOA.DEFICIENTEFALA,0) = 0 THEN '9'
	     WHEN ISNULL(PPESSOA.DEFICIENTEMENTAL,0) +   ISNULL(PPESSOA.DEFICIENTEVISUAL,0) + ISNULL(PPESSOA.DEFICIENTEAUDITIVO,0) + ISNULL(PPESSOA.DEFICIENTEFISICO,0) > 1 THEN '5'
	     WHEN ISNULL(PPESSOA.DEFICIENTEMENTAL,0) = 1   THEN '1'
	     WHEN ISNULL(PPESSOA.DEFICIENTEVISUAL,0) = 1   THEN '2'
	     WHEN ISNULL(PPESSOA.DEFICIENTEAUDITIVO,0) = 1 THEN '3'
	     WHEN ISNULL(PPESSOA.DEFICIENTEFISICO,0) = 1   THEN '4' 
	END MAT_NECESSIDADESPECIAIS,
	SUBSTRING(PPESSOA.RUA,0,120) MAT_RUA, 
	LEFT(PPESSOA.NUMERO,20) MAT_NUMERO,
	REPLACE(SUBSTRING(PPESSOA.COMPLEMENTO,0,100),';','') MAT_COMPLEMENTO,
	LEFT(PPESSOA.BAIRRO,20) MAT_BAIRRO,
	SUBSTRING(PPESSOA.CIDADE,0,40) MAT_CIDADE,
	PPESSOA.ESTADO MAT_ESTADO,
	SUBSTRING(REPLACE(REPLACE(REPLACE(PPESSOA.CEP,'-',''),'.',''),'/',''),0,8) MAT_CEP,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PPESSOA.TELEFONE1,')',''),'(',''),'.',''),'-',''),' ',''),2) MAT_DDD,
	SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PPESSOA.TELEFONE1,')',''),'(',''),'.',''),'-',''),' ',''),3,13) MAT_TELEFONE,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PPESSOA.TELEFONE2,')',''),'(',''),'.',''),'-',''),' ',''),2) MAT_DDDCELULAR,
	SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PPESSOA.TELEFONE2,')',''),'(',''),'.',''),'-',''),' ',''),3,13) MAT_CELULAR, 
	REPLACE(SUBSTRING(PPESSOA.EMAIL,0,100),';','') MAT_EMAIL,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'J' THEN 'PJ'
	     WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN 'PF' 
	ELSE '' 
	END AS MAT_PESSOAFISOUJUR,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'J' THEN REPLACE(REPLACE(REPLACE(EMPRESARESP.CGCCFO,'-',''),'.',''),'/','') ELSE '' END RESPF_CNPJ,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN REPLACE(REPLACE(REPLACE(EMPRESARESP.CGCCFO,'-',''),'.',''),'/','') ELSE '' END RESPF_CPF,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'J' THEN LEFT(EMPRESARESP.NOMEFANTASIA,120) ELSE '' END RESPJ_NOME,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(EMPRESARESP.NOMEFANTASIA,80) ELSE '' END RESPF_NOME,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(EMPRESARESP.RUA,120) ELSE '' END RESPF_RUA,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(EMPRESARESP.NUMERO,20) ELSE '' END RESPF_NUMERO,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(EMPRESARESP.COMPLEMENTO,100) ELSE '' END RESPF_COMPLEMENTO,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(EMPRESARESP.BAIRRO,20) ELSE '' END RESPF_BAIRRO,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN LEFT(GMUNICIPIO.NOMEMUNICIPIO,40) ELSE '' END RESPF_MUNICIPIO,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN EMPRESARESP.CODETD ELSE '' END RESPF_ESTADO,
	CASE WHEN EMPRESARESP.PESSOAFISOUJUR = 'F' THEN SUBSTRING(REPLACE(REPLACE(REPLACE(EMPRESARESP.CEP,'-',''),'.',''),'/',''),0,8) ELSE '' END RESPF_CEP,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EMPRESARESP.TELEFONE,')',''),'(',''),'.',''),'-',''),' ',''),20) RESPF_TELEFONE,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EMPRESARESP.FAX,')',''),'(',''),'.',''),'-',''),' ',''),20) RESPF_FAX,
	LEFT(EMPRESARESP.EMAIL,100) RESPF_EMAIL,
	LEFT(EMPRESARESP.CONTATO,100) RESPF_CONTATO
	
	
FROM   


	SMATRICPL (NOLOCK)
	
JOIN SHABILITACAOALUNO (NOLOCK)
ON   SHABILITACAOALUNO.CODCOLIGADA 			= SMATRICPL.CODCOLIGADA 
AND  SHABILITACAOALUNO.IDHABILITACAOFILIAL 	= SMATRICPL.IDHABILITACAOFILIAL 
AND  SHABILITACAOALUNO.RA 					= SMATRICPL.RA

JOIN SHABILITACAOALUNOCOMPL (NOLOCK) 
ON   SHABILITACAOALUNOCOMPL.CODCOLIGADA 		= SHABILITACAOALUNO.CODCOLIGADA 
AND  SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL 
AND  SHABILITACAOALUNOCOMPL.RA 					= SHABILITACAOALUNO.RA

JOIN SMATRICPLCOMPL (NOLOCK) 
ON   SMATRICPLCOMPL.CODCOLIGADA 		= SMATRICPL.CODCOLIGADA 
AND  SMATRICPLCOMPL.IDPERLET 			= SMATRICPL.IDPERLET 
AND  SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
AND  SMATRICPLCOMPL.RA 					= SMATRICPL.RA

JOIN SALUNO (NOLOCK) 
ON   SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
AND  SALUNO.RA 			= SHABILITACAOALUNO.RA

JOIN SALUNOCOMPL (NOLOCK) 
ON SALUNOCOMPL.CODCOLIGADA = SALUNO.CODCOLIGADA 
AND SALUNOCOMPL.RA = SALUNO.RA

LEFT JOIN SCONTRATO 
ON  SCONTRATO.CODCOLIGADA 			= SMATRICPL.CODCOLIGADA 
AND SCONTRATO.IDPERLET 				= SMATRICPL.IDPERLET 
AND SCONTRATO.IDHABILITACAOFILIAL 	= SMATRICPL.IDHABILITACAOFILIAL 
AND SCONTRATO.RA 					= SMATRICPL.RA
AND SCONTRATO.CODCONTRATO 			= (SELECT MAX(CODCONTRATO) FROM SCONTRATO SC(NOLOCK)
										WHERE SMATRICPL.CODCOLIGADA   		 	= SC.CODCOLIGADA
										AND   SMATRICPL.RA     	   		 		= SC.RA
										AND	  SMATRICPL.IDHABILITACAOFILIAL 	= SC.IDHABILITACAOFILIAL
										AND   SMATRICPL.IDPERLET 			 	= SC.IDPERLET)
								
LEFT JOIN SRESPONSAVELCONTRATO (NOLOCK)
ON  SRESPONSAVELCONTRATO.CODCOLIGADA 	= SCONTRATO.CODCOLIGADA 
AND SRESPONSAVELCONTRATO.RA 			= SCONTRATO.RA 
AND SRESPONSAVELCONTRATO.CODCONTRATO 	= SCONTRATO.CODCONTRATO 
AND SRESPONSAVELCONTRATO.IDPERLET 		= SCONTRATO.IDPERLET

LEFT JOIN SLOGPLETIVO (NOLOCK) 
ON  SLOGPLETIVO.CODCOLIGADA 		= SMATRICPL.CODCOLIGADA 
AND SLOGPLETIVO.IDPERLET 			= SMATRICPL.IDPERLET 
AND SLOGPLETIVO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
AND SLOGPLETIVO.CODTURMA 			= SMATRICPL.CODTURMA 
AND SLOGPLETIVO.RA 					= SMATRICPL.RA 
AND SLOGPLETIVO.DTALTERACAO 		= (SELECT MAX( ULTIMAALTERACAO.DTALTERACAO)FROM SLOGPLETIVO (NOLOCK) ULTIMAALTERACAO
												 	WHERE ULTIMAALTERACAO.CODCOLIGADA = SLOGPLETIVO.CODCOLIGADA
													AND   ULTIMAALTERACAO.CODFILIAL = SLOGPLETIVO.CODFILIAL 
													AND   ULTIMAALTERACAO.IDPERLET = SLOGPLETIVO.IDPERLET 
													AND   ULTIMAALTERACAO.IDHABILITACAOFILIAL = SLOGPLETIVO.IDHABILITACAOFILIAL 
													AND   ULTIMAALTERACAO.RA = SLOGPLETIVO.RA 
													AND   ULTIMAALTERACAO.CODTURMA = SLOGPLETIVO.CODTURMA 
													AND   ULTIMAALTERACAO.OPERACAO NOT IN ('I','E'))

LEFT JOIN GFILIAL (NOLOCK)
ON  GFILIAL.CODCOLIGADA	= SMATRICPL.CODCOLIGADA 
AND GFILIAL.CODFILIAL	= SMATRICPL.CODFILIAL

LEFT JOIN FCFO EMPRESARESP (NOLOCK)
ON  EMPRESARESP.CODCOLIGADA = SRESPONSAVELCONTRATO.CODCOLCFO	
AND EMPRESARESP.CODCFO 		= SRESPONSAVELCONTRATO.CODCFO

LEFT JOIN GMUNICIPIO 
ON  GMUNICIPIO.CODMUNICIPIO 	= GFILIAL.CODMUNICIPIO 
AND GMUNICIPIO.CODETDMUNICIPIO 	= GFILIAL.ESTADO

JOIN PPESSOA (NOLOCK) 
ON   PPESSOA.CODIGO = SALUNO.CODPESSOA

JOIN STURMA (NOLOCK) 
ON   STURMA.CODCOLIGADA  = SMATRICPL.CODCOLIGADA 
AND  STURMA.CODFILIAL 	 = SMATRICPL.CODFILIAL 
AND  STURMA.CODTURMA 	 = SMATRICPL.CODTURMA 
AND  STURMA.IDPERLET 	 = SMATRICPL.IDPERLET

JOIN STURMACOMPL (NOLOCK) 
ON   STURMACOMPL.CODCOLIGADA 	= STURMA.CODCOLIGADA 
AND  STURMACOMPL.CODFILIAL 		= STURMA.CODFILIAL 
AND  STURMACOMPL.CODTURMA 		= STURMA.CODTURMA 
AND  STURMACOMPL.IDPERLET 		= STURMA.IDPERLET

LEFT JOIN GCONSIST LINHAACAO(NOLOCK) 
ON  STURMACOMPL.LINHACAO 	= LINHAACAO.CODINTERNO 
AND LINHAACAO.CODTABELA 	= 'LINHASACAO'

LEFT JOIN GCONSIST TIPOGRAT(NOLOCK)
ON  SHABILITACAOALUNOCOMPL.TIPOGRAT = TIPOGRAT.CODINTERNO 
AND TIPOGRAT.CODTABELA 				= 'TIPOGRAT'

LEFT JOIN GCONSIST INDICADOR(NOLOCK) 
ON   SHABILITACAOALUNOCOMPL.PRONATEC 	= INDICADOR.CODINTERNO 
AND  INDICADOR.CODTABELA 				= 'INDICADOR'

JOIN SHABILITACAOFILIAL (NOLOCK) 
ON   SHABILITACAOFILIAL.CODCOLIGADA 		= SHABILITACAOALUNO.CODCOLIGADA 
AND  SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL

JOIN STURNO 
ON   STURNO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA 
AND  STURNO.CODTURNO 	= SHABILITACAOFILIAL.CODTURNO

JOIN SGRADE (NOLOCK) 
ON   SGRADE.CODCOLIGADA 	= SHABILITACAOFILIAL.CODCOLIGADA 
AND  SGRADE.CODCURSO 		= SHABILITACAOFILIAL.CODCURSO 
AND  SGRADE.CODHABILITACAO 	= SHABILITACAOFILIAL.CODHABILITACAO 
AND  SGRADE.CODGRADE 		= SHABILITACAOFILIAL.CODGRADE

JOIN SGRADECOMPL (NOLOCK)
ON   SGRADECOMPL.CODCOLIGADA 	= SGRADE.CODCOLIGADA 
AND  SGRADECOMPL.CODCURSO 		= SGRADE.CODCURSO 
AND  SGRADECOMPL.CODHABILITACAO = SGRADE.CODHABILITACAO 
AND  SGRADECOMPL.CODGRADE 		= SGRADE.CODGRADE

JOIN SHABILITACAO (NOLOCK)
ON   SHABILITACAO.CODCOLIGADA = SGRADE.CODCOLIGADA 
AND  SHABILITACAO.CODCURSO = SGRADE.CODCURSO 
AND  SHABILITACAO.CODHABILITACAO = SGRADE.CODHABILITACAO

JOIN SCURSO (NOLOCK) 
ON 	 SCURSO.CODCOLIGADA = SHABILITACAO.CODCOLIGADA 
AND  SCURSO.CODCURSO 	= SHABILITACAO.CODCURSO

JOIN SCURSOCOMPL (NOLOCK)
ON   SCURSOCOMPL.CODCOLIGADA 	= SCURSO.CODCOLIGADA 
AND  SCURSOCOMPL.CODCURSO 		= SCURSO.CODCURSO

JOIN SMODALIDADECURSO 
ON   SMODALIDADECURSO.CODCOLIGADA 		 = SCURSO.CODCOLIGADA 
AND  SMODALIDADECURSO.CODMODALIDADECURSO = SCURSO.CODMODALIDADECURSO

JOIN SSTATUS (NOLOCK) 
ON   SSTATUS.CODCOLIGADA 	= SMATRICPL.CODCOLIGADA 
AND  SSTATUS.CODSTATUS 		= SMATRICPL.CODSTATUS

WHERE  
	SCURSO.CODCOLIGADA = 3 
	AND STURMA.DTFINAL >= @DATADE AND STURMA.DTINICIAL <= @DATAATE 
	AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
	AND ((CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) >= @DATADE)OR (SMATRICPL.CODSTATUS = '2'))
	AND STURMACOMPL.TIPOTURMA NOT IN ('11','12')
	AND SMATRICPL.CODSTATUS    != 1
) TAB 

WHERE TAB.MAT_SITUACAO IS NOT NULL