SELECT  SMATRICPL.CODCOLIGADA,  
  SMATRICPL.CODFILIAL,  
  GFILIAL.NOME AS 'NOMEFILIAL',  
  STIPOCURSO.CODTIPOCURSO AS 'CODCONTEXTO',  
  STIPOCURSO.NOME AS 'NOMECONTEXTO',  
  SHABILITACAOFILIAL.CODCURSO,  
  SCURSO.NOME AS 'NOMECURSO',
  SMODALIDADECURSO.DESCRICAO AS 'MODALIDADE',  
  SHABILITACAOFILIAL.IDHABILITACAOFILIAL,  
  SHABILITACAOFILIAL.CODGRADE,  
  SGRADE.DESCRICAO DESCGRADE,  
  SHABILITACAO.CODHABILITACAO,  
  SHABILITACAO.NOME AS 'NOMEHABILITACAO',  
  SPLETIVO.IDPERLET,  
  SPLETIVO.CODPERLET,  
  SPLETIVO.DESCRICAO,  
  SMATRICPL.RA,  
  SMATRICPLCOMPL.TIPOCLI,
  SMATRICPLCOMPL.CATEGORIA,
  PPESSOA.CODIGO,  
  PPESSOA.IDIMAGEM,  
  PPESSOA.NOME AS 'ALUNO',  
  CONVERT(CHAR,PPESSOA.DTNASCIMENTO,103) AS 'DATANASCIMENTO',  
  CASE PPESSOA.SEXO WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Feminino' END SEXO,  
  PAI.NOME AS 'PAI',  
  PAI.CODIGO CODPESSOAPAI,  
  MAE.NOME AS 'MAE',  
  MAE.CODIGO CODPESSOAMAE,  
  PPESSOA.RUA,  
  PPESSOA.NUMERO,  
  PPESSOA.COMPLEMENTO,  
  PPESSOA.BAIRRO,  
  PPESSOA.ESTADO,  
  PPESSOA.CIDADE,  
  PPESSOA.CEP,  
  PPESSOA.TELEFONE1,  
  PPESSOA.TELEFONE2,  
  PPESSOA.TELEFONE3,  
  PPESSOA.FAX,  
  PPESSOA.EMAIL,  
  PCODNACAO.DESCRICAO NACIONALIDADE,  
  PPESSOA.CPF,  
  PPESSOA.CARTIDENTIDADE,  
  PPESSOA.NPASSAPORTE,  
  PPESSOA.NATURALIDADE,  
  SPESSOA.EMPRESANOME,  
  SPESSOA.EMPRESATELEFONE,  
  ETABOCUP.DESCRICAO FUNCAOCARGO,  
  SALUNO.CODCOLCFO AS COLIGADACFO,  
  SALUNO.CODCFO AS CODRESPFINANC,  
  FCFO.NOMEFANTASIA AS RESPFINANC,  
  SALUNO.CODPESSOARACA AS CODRESPACADEM,  
  RESPACADEM.NOME AS RESPACADEM,  
  SHABILITACAOALUNO.DTINGRESSO,  
  STIPOINGRESSO.DESCRICAO AS TIPOINGRESSO,  
  CONVERT(CHAR,SMATRICPL.DTMATRICULA,103) AS 'DTMATRICPL',  
  SMATRICPL.CODSTATUS AS 'CODSTATMATRICPL',  
  SSTATUS.DESCRICAO AS 'STATMATRICPL',  
  STURNO.CODTURNO,  
  STURNO.NOME AS 'NOMEDOTURNO',  
  SGRADE.TOTALCREDITOS,  
  SGRADE.CARGAHORARIA CHMATRIZ,  
  CASE WHEN ISNULL(PPESSOA.DEFICIENTEAUDITIVO, 0) + ISNULL(PPESSOA.DEFICIENTEFALA,0) + ISNULL(PPESSOA.DEFICIENTEFISICO,0) + ISNULL(PPESSOA.DEFICIENTEMENTAL,0) + ISNULL(PPESSOA.DEFICIENTEVISUAL,0) + ISNULL(PPESSOA.DEFICIENTEMOBREDUZIDA,0) > 0 THEN 'Sim' ELSE 'N�o' END DEFICIENTE,  
  PCODINSTRUCAO.DESCRICAO AS 'ESCOLARIDADE',  
  SMATRICPL.RECCREATEDBY USUARIOCRIACAO,  
  PCORRACA.DESCRICAO CORRACA,    
  CASE PPESSOA.ESTADOCIVIL WHEN 'S' THEN 'Solteiro' WHEN 'C' THEN 'Casado' END ESTADOCIVIL,  
  SMATRICPL.CODTURMA,
  SMATRICPL.NUMALUNO,
  CASE
		WHEN SMATRICPL.CODTIPOMAT = 1 THEN 'NOVATO'
		WHEN SMATRICPL.CODTIPOMAT = 2 THEN 'VETERANO'
		ELSE NULL
  END AS CODTIPOMAT,
  SMATRICPL.DTMATRICULA
  
FROM SMATRICPL (NOLOCK)  
 INNER JOIN SMATRICPLCOMPL ON SMATRICPLCOMPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SMATRICPLCOMPL.IDPERLET = SMATRICPL.IDPERLET AND SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SMATRICPLCOMPL.RA = SMATRICPL.RA
 INNER JOIN GCOLIGADA (NOLOCK)  
   ON SMATRICPL.CODCOLIGADA = GCOLIGADA.CODCOLIGADA  
 INNER JOIN SALUNO (NOLOCK)   
   ON  SMATRICPL.CODCOLIGADA = SALUNO.CODCOLIGADA   
   AND SMATRICPL.RA = SALUNO.RA  
 INNER JOIN GFILIAL(NOLOCK)  
   ON  SMATRICPL.CODCOLIGADA = GFILIAL.CODCOLIGADA  
   AND SMATRICPL.CODFILIAL = GFILIAL.CODFILIAL  
 INNER JOIN SPESSOA (NOLOCK)   
   ON  SALUNO.CODPESSOA = SPESSOA.CODIGO  
 INNER JOIN PPESSOA (NOLOCK)   
   ON  SPESSOA.CODIGO = PPESSOA.CODIGO  
 LEFT JOIN PPESSOA PAI(NOLOCK)  
   ON  SPESSOA.CODPESSOAPAI = PAI.CODIGO  
 LEFT JOIN PPESSOA MAE(NOLOCK)  
   ON  SPESSOA.CODPESSOAMAE = MAE.CODIGO  
 LEFT JOIN PCODNACAO (NOLOCK)  
   ON  PCODNACAO.CODCLIENTE = PPESSOA.NACIONALIDADE  
 LEFT JOIN ETABOCUP(NOLOCK)  
   ON  PPESSOA.CODOCUPACAO = ETABOCUP.CODCLIENTE  
 LEFT JOIN FCFO(NOLOCK)  
   ON  FCFO.CODCOLIGADA = SALUNO.CODCOLIGADA  
   AND FCFO.CODCFO = SALUNO.CODCFO  
 LEFT JOIN PPESSOA RESPACADEM (NOLOCK)   
   ON  SALUNO.CODPESSOARACA = RESPACADEM.CODIGO  
 INNER JOIN SPLETIVO (NOLOCK)  
   ON  SMATRICPL.IDPERLET = SPLETIVO.IDPERLET   
   AND SMATRICPL.CODCOLIGADA = SPLETIVO.CODCOLIGADA   
 INNER JOIN SHABILITACAOALUNO(NOLOCK)  
   ON  SMATRICPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA  
   AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL  
   AND SMATRICPL.RA = SHABILITACAOALUNO.RA  
 INNER JOIN SHABILITACAOFILIAL (NOLOCK)   
   ON  SHABILITACAOALUNO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA   
   AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL   
 INNER JOIN SHABILITACAO (NOLOCK)   
   ON  SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAO.CODCOLIGADA   
   AND SHABILITACAOFILIAL.CODCURSO = SHABILITACAO.CODCURSO   
   AND SHABILITACAOFILIAL.CODHABILITACAO = SHABILITACAO.CODHABILITACAO  
 LEFT JOIN STIPOINGRESSO(NOLOCK)  
   ON STIPOINGRESSO.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA  
   AND STIPOINGRESSO.CODTIPOINGRESSO = SHABILITACAOALUNO.CODTIPOINGRESSO  
 INNER JOIN SGRADE(NOLOCK)  
   ON  SHABILITACAOFILIAL.CODCOLIGADA = SGRADE.CODCOLIGADA   
   AND SHABILITACAOFILIAL.CODCURSO = SGRADE.CODCURSO   
   AND SHABILITACAOFILIAL.CODHABILITACAO = SGRADE.CODHABILITACAO  
   AND SHABILITACAOFILIAL.CODGRADE = SGRADE.CODGRADE  
 LEFT JOIN SGRADECOMPL(NOLOCK)  
   ON  SGRADECOMPL.CODCOLIGADA = SGRADE.CODCOLIGADA   
   AND SGRADECOMPL.CODCURSO = SGRADE.CODCURSO   
   AND SGRADECOMPL.CODHABILITACAO = SGRADE.CODHABILITACAO  
   AND SGRADECOMPL.CODGRADE = SGRADE.CODGRADE  
 INNER JOIN STURNO (NOLOCK)   
   ON  SHABILITACAOFILIAL.CODCOLIGADA = STURNO.CODCOLIGADA   
   AND SHABILITACAOFILIAL.CODTURNO = STURNO.CODTURNO  
 LEFT JOIN SHABILITACAOFILIALCAMPUS (NOLOCK)   
   ON  SHABILITACAOFILIALCAMPUS.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA  
   AND SHABILITACAOFILIALCAMPUS.IDHABILITACAOFILIAL = SHABILITACAOFILIAL.IDHABILITACAOFILIAL  
 LEFT JOIN SCAMPUS(NOLOCK)  
   ON  SCAMPUS.CODCAMPUS = SHABILITACAOFILIALCAMPUS.CODCAMPUS  
 LEFT JOIN SHABILITACAOCOMPL (NOLOCK)   
   ON  SHABILITACAO.CODCOLIGADA = SHABILITACAOCOMPL.CODCOLIGADA   
   AND SHABILITACAO.CODCURSO = SHABILITACAOCOMPL.CODCURSO   
   AND SHABILITACAO.CODHABILITACAO = SHABILITACAOCOMPL.CODHABILITACAO  
 INNER JOIN STIPOCURSO(NOLOCK)  
   ON  STIPOCURSO.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA  
   AND STIPOCURSO.CODTIPOCURSO = SHABILITACAOFILIAL.CODTIPOCURSO  
   INNER JOIN SSTATUS (NOLOCK)   
   ON  SMATRICPL.CODCOLIGADA = SSTATUS.CODCOLIGADA   
   AND SMATRICPL.CODSTATUS = SSTATUS.CODSTATUS  
 INNER JOIN SCURSO (NOLOCK)   
   ON  SHABILITACAOFILIAL.CODCOLIGADA  = SCURSO.CODCOLIGADA   
   AND SHABILITACAOFILIAL.CODCURSO = SCURSO.CODCURSO
 INNER JOIN SMODALIDADECURSO(NOLOCK)
   ON  SCURSO.CODCOLIGADA = SMODALIDADECURSO.CODCOLIGADA 
   AND SCURSO.CODMODALIDADECURSO = SMODALIDADECURSO.CODMODALIDADECURSO  
 LEFT JOIN SCURSOCOMPL(NOLOCK)  
   ON  SCURSOCOMPL.CODCOLIGADA  = SCURSO.CODCOLIGADA   
   AND SCURSOCOMPL.CODCURSO = SCURSO.CODCURSO  
 LEFT JOIN PCODINSTRUCAO (NOLOCK)  
   ON  PPESSOA.GRAUINSTRUCAO = PCODINSTRUCAO.CODINTERNO  
 LEFT JOIN PCORRACA(NOLOCK)  
   ON PCORRACA.CODINTERNO = PPESSOA.CORRACA  
WHERE
SMATRICPL.CODCOLIGADA = 3 AND
SGRADE.CODGRADE = '2106002181'