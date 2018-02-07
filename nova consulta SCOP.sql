DECLARE @DATADE  DATETIME
DECLARE @DATAATE DATETIME

SET @DATADE = '2018-01-01'
SET @DATAATE = '2018-31-01'

SELECT 

TAB.MAT_CODMATRICULA,
TAB.MAT_DATAENTRMATRICULA,
TAB.MAT_DATAPREVTERMI,
CASE WHEN TAB.MAT_SITUACAO != 2 THEN TAB.MAT_DATAREALTERM ELSE NULL END AS 'DT_SAIDA',
--TAB.MAT_DATAREALTERM,
TAB.MAT_MUNEXECUCAO,
TAB.MAT_CODALUNO,
TAB.MAT_SITUACAO

FROM

(SELECT 
	DISTINCT
	2 AS TIPOREG,
	NULL AS OPERACAO,
	LEFT(ISNULL(SHABILITACAOALUNOCOMPL.IDMATRICSI,(CONCAT(SMATRICPL.RA,SMATRICPL.IDHABILITACAOFILIAL))),20) AS  MAT_CODMATRICULA,
	CASE
		WHEN STURMA.CODFILIAL = 1 THEN '1117267'
		WHEN STURMA.CODFILIAL = 3 THEN '1140762'
		WHEN STURMA.CODFILIAL = 4 THEN '1117394'
		WHEN STURMA.CODFILIAL = 5 THEN '1140770'
		WHEN STURMA.CODFILIAL = 6 THEN '1117390'
		WHEN STURMA.CODFILIAL = 7 THEN '1117392'
		WHEN STURMA.CODFILIAL = 8 THEN '1117391'
		WHEN STURMA.CODFILIAL = 9 THEN '1117393'
		WHEN STURMA.CODFILIAL = 10 THEN '2363593'
		WHEN STURMA.CODFILIAL = 12 THEN '2364068'
		WHEN STURMA.CODFILIAL = 13 THEN '5141455'
		WHEN STURMA.CODFILIAL = 14 THEN '5155974'
		WHEN STURMA.CODFILIAL = 15 THEN '5156123'
	END AS MAT_UNIDADEATEND,
	LEFT(ISNULL(SHABILITACAOALUNOCOMPL.CODCURSO,ISNULL(SGRADECOMPL.CURSOSCOP, ISNULL(SGRADECOMPL.IDSOLUCAOINTEGRADORA,SGRADE.CODGRADE))),20) AS MAT_CODCURSO,
	CASE WHEN SCURSO.CURPRESDIST = 'D' THEN 2 ELSE 1 END MAT_ACAO,
	STURMACOMPL.TIPOAMB MAT_TIPOAMBIENTE,
	CASE 
		WHEN SHABILITACAOALUNOCOMPL.DATAINICIAL IS NOT NULL THEN CONVERT(VARCHAR,SHABILITACAOALUNOCOMPL.DATAINICIAL,103)
		WHEN ((SMATRICPL.DTMATRICULA < STURMA.DTINICIAL) OR (STURMA.DTINICIAL = STURMA.DTFINAL)) THEN CONVERT(VARCHAR,STURMA.DTINICIAL,103)
		ELSE CONVERT(VARCHAR,SMATRICPL.DTMATRICULA,103)
	END MAT_DATAENTRMATRICULA,
	CASE
		WHEN SHABILITACAOALUNOCOMPL.DATAFINAL IS NOT NULL THEN CONVERT(VARCHAR,SHABILITACAOALUNOCOMPL.DATAFINAL,103)
		--WHEN STURMACOMPL.DTFIMSI IS NOT NULL THEN CONVERT(VARCHAR,STURMACOMPL.DTFIMSI,103)
		ELSE CONVERT(VARCHAR(10),CONVERT(DATE,STURMA.DTFINAL),103)
	END AS MAT_DATAPREVTERMI,
	
		CASE
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND CONVERT(DATE,STURMA.DTFINAL) < @DATAATE) THEN CONVERT(VARCHAR,STURMA.DTFINAL,103)
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) < @DATAATE AND CONVERT(DATE,STURMA.DTFINAL) < @DATAATE) THEN CONVERT(VARCHAR,STURMA.DTFINAL,103)
		ELSE CONVERT(VARCHAR,SLOGPLETIVO.DTALTERACAO,103)
		END AS MAT_DATAREALTERM,
		
	CONCAT(32,GFILIAL.CODMUNICIPIO) MAT_MUNEXECUCAO,
	 CASE 
		WHEN SALUNOCOMPL.ALUNOSCOP IS NOT NULL THEN SALUNOCOMPL.ALUNOSCOP
		ELSE SALUNO.RA END MAT_CODALUNO,
	/*STATUS*/
	
	CASE
		WHEN (CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATAATE AND CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL) > @DATAATE)
			THEN 
		   	(SELECT SLG.CODSTATUS 
				FROM SLOGPLETIVO SLG 
				WHERE 
				(CONVERT(DATE,SLG.DTALTERACAO) < @DATAATE) 
				AND SLG.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
				AND SLG.IDPERLET = SMATRICPL.IDPERLET 
				AND SLG.CODFILIAL = SMATRICPL.CODFILIAL 
				AND SLG.CODTURMA = SMATRICPL.CODTURMA 
				AND SLG.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL
				AND SLG.RA = SMATRICPL.RA)
				
		ELSE
		SMATRICPL.CODSTATUS
	END	AS MAT_SITUACAO,
	
	CASE 
		WHEN SMATRICPL.CODTIPOMAT IN ('1','2') THEN '1'
		WHEN SMATRICPL.CODTIPOMAT = '5' THEN '2'
		WHEN SMATRICPL.CODTIPOMAT = '6' THEN '3'
	END AS MAT_TIPOENTRADA,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '3' THEN 9
	     ELSE SHABILITACAOALUNOCOMPL.CONDALUNO
	END AS MAT_CONDALU,
	CASE WHEN SHABILITACAOALUNOCOMPL.ARTICULACAO = '1' THEN 'S' ELSE 'N' END AS MAT_ARTICULACAO,
	CASE WHEN SHABILITACAOALUNOCOMPL.TIPOGRAT = 5 THEN 9 ELSE SHABILITACAOALUNOCOMPL.TIPOGRAT END MAT_TIPOGRAT,
	ISNULL(SALUNOCOMPL.TIPOESCOLA,'9') MAT_TIPOESCOLA, /* 9 = NAO DECLARADO*/
	SHABILITACAOALUNOCOMPL.PRONATEC MAT_INDPRONATEC,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '1' AND SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') THEN CONVERT(VARCHAR(10),CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAINICIAL),103) ELSE NULL
	     END AS MAT_DATAINIVIGENCIA,
	CASE WHEN SHABILITACAOALUNOCOMPL.CONDALUNO = '1' AND SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') THEN CONVERT(VARCHAR(10),CONVERT(DATE,SHABILITACAOALUNOCOMPL.DATAFINAL),103) ELSE NULL
	     END AS MAT_DATAFIMVIGENCIA,
	ISNULL(SGRADECOMPL.CHPPC,0) AS MAT_PRATICAPROFISSIONAL,
	0 AS MAT_CI1,
	0 AS MAT_CI2,
	0 AS MAT_CI3,
	0 AS MAT_CI4,
	0 AS MAT_CI5,
	0 AS MAT_CI6, 
	CASE WHEN LEN(EMPRESARESP.CGCCFO) <= 14 THEN ''
		ELSE
		CASE WHEN SCURSO.CODMODALIDADECURSO IN ('11','15','31','33') AND SHABILITACAOALUNOCOMPL.CONDALUNO = '1' THEN SUBSTRING(REPLACE(REPLACE(REPLACE(EMPRESARESP.CGCCFO,'-',''),'.',''),'/',''),0,20)
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
	PPESSOA.SEXO MAT_SEXO,
	CASE WHEN PPESSOA.CORRACA = 2  THEN '1'
	     WHEN PPESSOA.CORRACA = 4  THEN '2'
	     WHEN PPESSOA.CORRACA = 8  THEN '3'
	     WHEN PPESSOA.CORRACA = 6  THEN '4'
	     WHEN PPESSOA.CORRACA = 0  THEN '5'
	ELSE '6' END MAT_CORRACA,
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
	     WHEN 'V' THEN '5'  /* Viúvo */
	     ELSE '6'
	END MAT_ESTADOCIVIL,
	CASE WHEN PPESSOA.GRAUINSTRUCAO IN ('2','3','4') THEN '1'
	     WHEN PPESSOA.GRAUINSTRUCAO = '5'     THEN '2'
	     WHEN PPESSOA.GRAUINSTRUCAO = '6'     THEN '3'
	     WHEN PPESSOA.GRAUINSTRUCAO = '7'     THEN '4'
	     WHEN PPESSOA.GRAUINSTRUCAO = '8'     THEN '5'
	     WHEN PPESSOA.GRAUINSTRUCAO IN ('9','A','B','C','D','E','F','G','H') THEN '6'
	END MAT_GRAUINSTRUCAO,
	ISNULL(SALUNOCOMPL.SITUACAOOCUP,'2') MAT_SITOCUP, /* TIRAR APÓS ACERTO DA UNIDADE*/
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
	CASE WHEN FCFO.PAGREC = 1 THEN 'PJ'
	     WHEN FCFO.PAGREC = 2 THEN 'PF' ELSE '' END AS MAT_PESSOAFISOUJUR,
	CASE WHEN FCFO.PAGREC = 1 THEN REPLACE(REPLACE(REPLACE(FCFO.CGCCFO,'-',''),'.',''),'/','') ELSE '' END RESPF_CNPJ,
	CASE WHEN FCFO.PAGREC = 2 THEN REPLACE(REPLACE(REPLACE(FCFO.CGCCFO,'-',''),'.',''),'/','') ELSE '' END RESPF_CPF,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(FCFO.NOMEFANTASIA,80) ELSE '' END RESPF_NOME,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(FCFO.RUA,120) ELSE '' END RESPF_RUA,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(FCFO.NUMERO,20) ELSE '' END RESPF_NUMERO,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(FCFO.COMPLEMENTO,100) ELSE '' END RESPF_COMPLEMENTO,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(FCFO.BAIRRO,20) ELSE '' END RESPF_BAIRRO,
	CASE WHEN FCFO.PAGREC = 2 THEN LEFT(GMUNICIPIO.NOMEMUNICIPIO,40) ELSE '' END RESPF_MUNICIPIO,
	CASE WHEN FCFO.PAGREC = 2 THEN FCFO.CODETD ELSE '' END RESPF_ESTADO,
	CASE WHEN FCFO.PAGREC = 2 THEN SUBSTRING(REPLACE(REPLACE(REPLACE(FCFO.CEP,'-',''),'.',''),'/',''),0,8) ELSE '' END RESPF_CEP,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(FCFO.TELEFONE,')',''),'(',''),'.',''),'-',''),' ',''),20) RESPF_TELEFONE,
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(FCFO.FAX,')',''),'(',''),'.',''),'-',''),' ',''),20) RESPF_FAX,
	LEFT(FCFO.EMAIL,100) RESPF_EMAIL,
	LEFT(FCFO.CONTATO,100) RESPF_CONTATO
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
		
	JOIN SHABILITACAOALUNO (NOLOCK) 
		ON SHABILITACAOALUNO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA 
		AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL
	
	JOIN SHABILITACAOALUNOCOMPL (NOLOCK)
		ON SHABILITACAOALUNOCOMPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
		AND SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL 
		AND SHABILITACAOALUNOCOMPL.RA = SHABILITACAOALUNO.RA
	
	JOIN SMATRICPL (NOLOCK) 
		ON SMATRICPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
		AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL 
		AND SMATRICPL.RA = SHABILITACAOALUNO.RA 
		AND SMATRICPL.CODTURMA=STURMA.CODTURMA
		AND SMATRICPL.IDPERLET = STURMA.IDPERLET
		AND SMATRICPL.CODFILIAL= STURMA.CODFILIAL
		
	JOIN SMATRICPLCOMPL (NOLOCK) 
		ON SMATRICPLCOMPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
		AND SMATRICPLCOMPL.IDPERLET = SMATRICPL.IDPERLET 
		AND SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
		AND SMATRICPLCOMPL.RA = SMATRICPL.RA
	
	JOIN SALUNO (NOLOCK) 
		ON SALUNO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
		AND SALUNO.RA = SHABILITACAOALUNO.RA
	
	JOIN SALUNOCOMPL (NOLOCK) 
		ON SALUNOCOMPL.CODCOLIGADA = SALUNO.CODCOLIGADA 
		AND SALUNOCOMPL.RA = SALUNO.RA
	
	JOIN SSTATUS (NOLOCK) 
		ON SSTATUS.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA 
		AND SSTATUS.CODSTATUS = SHABILITACAOALUNO.CODSTATUS
	
	JOIN PPESSOA (NOLOCK) 
		ON PPESSOA.CODIGO=SALUNO.CODPESSOA
	
	LEFT JOIN SCONTRATO (NOLOCK) 
		ON SCONTRATO.CODCOLIGADA=SMATRICPL.CODCOLIGADA 
		AND SCONTRATO.RA=SMATRICPL.RA 
		AND SCONTRATO.IDHABILITACAOFILIAL=SMATRICPL.IDHABILITACAOFILIAL 
		AND SCONTRATO.IDPERLET=SMATRICPL.IDPERLET
	
	LEFT JOIN SRESPONSAVELCONTRATO (NOLOCK)
		ON SCONTRATO.CODCOLIGADA = SRESPONSAVELCONTRATO.CODCOLIGADA 
		AND SCONTRATO.RA = SRESPONSAVELCONTRATO.RA 
		AND SCONTRATO.CODCONTRATO = SRESPONSAVELCONTRATO.CODCONTRATO 
		AND SCONTRATO.IDPERLET = SRESPONSAVELCONTRATO.IDPERLET
	
	LEFT JOIN SLOGPLETIVO ON 
			SLOGPLETIVO.CODCOLIGADA = SMATRICPL.CODCOLIGADA 
		AND SLOGPLETIVO.IDPERLET = SMATRICPL.IDPERLET 
	    AND SLOGPLETIVO.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL 
		AND SLOGPLETIVO.CODTURMA = SMATRICPL.CODTURMA 
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
													 AND ULTIMAALTERACAO.OPERACAO != 'I'
																					 
											   )
	
	LEFT JOIN GFILIAL (NOLOCK) 
		ON GFILIAL.CODCOLIGADA=STURMA.CODCOLIGADA 
		AND GFILIAL.CODFILIAL=STURMA.CODFILIAL
	
	LEFT JOIN FCFO (NOLOCK) 
		ON FCFO.CODCOLIGADA=SALUNO.CODCOLIGADA 
		AND FCFO.CODCFO=SALUNO.CODCFO
	
	LEFT JOIN FCFO EMPRESARESP (NOLOCK) 
		ON EMPRESARESP.CODCOLIGADA = SRESPONSAVELCONTRATO.CODCOLCFO	
		AND EMPRESARESP.CODCFO = SRESPONSAVELCONTRATO.CODCFO
	
	LEFT JOIN GMUNICIPIO (NOLOCK) 
		ON FCFO.CODMUNICIPIO = GMUNICIPIO.CODMUNICIPIO
	
WHERE  
	SCURSO.CODCOLIGADA = 3 
	AND STURMA.DTFINAL >= @DATADE AND STURMA.DTINICIAL <= @DATAATE 
	--AND ((CONVERT(DATE,SMATRICPL.DTMATRICULA) < @DATADE) OR (CONVERT(DATE,SMATRICPL.DTMATRICULA) >= @DATADE AND CONVERT(DATE,SMATRICPL.DTMATRICULA) <= @DATAATE))
	--AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
	--OR (SHABILITACAOALUNOCOMPL.DATAFINAL >= @DATADE AND SHABILITACAOALUNOCOMPL.DATAINICIAL <= @DATAATE)
	AND ((CONVERT(DATE,SLOGPLETIVO.DTALTERACAO) > @DATADE)OR (SHABILITACAOALUNO.CODSTATUS  IN ('2','9','11','12','18')))
    AND STURMA.CODTURMA = 'EMP-NCA-05'
    AND STURMA.CODFILIAL = 13
	--AND SMATRICPL.CODSTATUS != 1
    --AND SMATRICPL.RA  = '0050181'
    
) TAB

WHERE 
TAB.MAT_SITUACAO != 1
--AND CONVERT(DATE,TAB.MAT_DATAREALTERM)
