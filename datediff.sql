SELECT 
SMATRICPL.CODFILIAL,
SALUNO.RA,
PPESSOA.SEXO,
PPESSOA.CORRACA,
PPESSOA.GRAUINSTRUCAO,
SHABILITACAOALUNOCOMPL.DATAINICIAL,
SHABILITACAOALUNOCOMPL.DATAFINAL

FROM SALUNO
INNER JOIN PPESSOA ON PPESSOA.CODIGO = SALUNO.CODPESSOA
INNER JOIN SHABILITACAOALUNO ON SHABILITACAOALUNO.CODCOLIGADA = SALUNO.CODCOLIGADA AND SHABILITACAOALUNO.RA = SALUNO.RA
INNER JOIN SHABILITACAOALUNOCOMPL ON SHABILITACAOALUNOCOMPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL AND SHABILITACAOALUNOCOMPL.RA = SHABILITACAOALUNO.RA
INNER JOIN SMATRICPL ON SMATRICPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL AND SMATRICPL.RA = SHABILITACAOALUNO.RA
INNER JOIN SMATRICPLCOMPL ON SMATRICPLCOMPL.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND SMATRICPLCOMPL.IDPERLET = SMATRICPL.IDPERLET AND SMATRICPLCOMPL.IDHABILITACAOFILIAL = SMATRICPL.IDHABILITACAOFILIAL AND SMATRICPLCOMPL.RA = SMATRICPL.RA
INNER JOIN STURMA ON STURMA.CODCOLIGADA = SMATRICPL.CODCOLIGADA AND STURMA.CODFILIAL = SMATRICPL.CODFILIAL AND STURMA.CODTURMA = SMATRICPL.CODTURMA AND STURMA.IDPERLET = SMATRICPL.IDPERLET
INNER JOIN STURMACOMPL ON STURMACOMPL.CODCOLIGADA = STURMA.CODCOLIGADA AND STURMACOMPL.CODFILIAL = STURMA.CODFILIAL AND STURMACOMPL.CODTURMA = STURMA.CODTURMA AND STURMACOMPL.IDPERLET = STURMA.IDPERLET
INNER JOIN SHABILITACAOFILIAL ON SHABILITACAOFILIAL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA AND SHABILITACAOFILIAL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL
INNER JOIN SGRADE ON SGRADE.CODCOLIGADA = SHABILITACAOFILIAL.CODCOLIGADA AND SGRADE.CODCURSO = SHABILITACAOFILIAL.CODCURSO AND SGRADE.CODHABILITACAO = SHABILITACAOFILIAL.CODHABILITACAO AND SGRADE.CODGRADE = SHABILITACAOFILIAL.CODGRADE
INNER JOIN SHABILITACAO ON SHABILITACAO.CODCOLIGADA = SGRADE.CODCOLIGADA AND SHABILITACAO.CODCURSO = SGRADE.CODCURSO AND SHABILITACAO.CODHABILITACAO = SGRADE.CODHABILITACAO
INNER JOIN SCURSO ON SCURSO.CODCOLIGADA = SHABILITACAO.CODCOLIGADA AND SCURSO.CODCURSO = SHABILITACAO.CODCURSO

WHERE 
STURMA.DTFINAL >= '2018-01-01'
AND STURMACOMPL.TIPOTURMA NOT IN ('11','12')
--AND PPESSOA.SEXO IS NULL
AND (SMATRICPLCOMPL.ENVIAPROD IS NULL OR SMATRICPLCOMPL.ENVIAPROD != 2)
AND SMATRICPL.CODSTATUS    != 1
AND (SCURSO.CODMODALIDADECURSO IN('15','31') AND DATEDIFF(DAY,SHABILITACAOALUNOCOMPL.DATAINICIAL,SHABILITACAOALUNOCOMPL.DATAFINAL) < 300)
/*OR PPESSOA.CORRACA IS NULL
OR PPESSOA.GRAUINSTRUCAO IS NULL
OR SHABILITACAOALUNOCOMPL.DATAINICIAL != STURMA.DTFINAL
OR(SCURSO.CODMODALIDADECURSO IN('15','31') AND DATEDIFF(DAY,SHABILITACAOALUNOCOMPL.DATAINICIAL,SHABILITACAOALUNOCOMPL.DATAFINAL) < 300))*/
