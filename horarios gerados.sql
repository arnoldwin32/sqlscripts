SELECT DISTINCT TAB.CODTURMA FROM(
SELECT 
	SH.AULA 'Aula',
	CASE 
	WHEN 
		SH.DIASEMANA=1 
	THEN 
		'Domingo'
    WHEN 
		SH.DIASEMANA=2 
	THEN 
		'Segunda-feira'
    WHEN
		SH.DIASEMANA=3 
	THEN 
		'Ter�a-feira'
    WHEN 
		SH.DIASEMANA=4 
	THEN 
		'Quarta-feira'
    WHEN 
		SH.DIASEMANA=5 
	THEN 
		'Quinta-feira'
    WHEN 
		SH.DIASEMANA=6 
	THEN 
		'Sexta-feira'
    WHEN 
		SH.DIASEMANA=7 
	THEN 
		'S�bado' 
	END 'Dia da Semana',
	PP.NOME 'Instrutor',
	SPA.CONTEUDO 'Conte�do Previsto',
	SPA.CONTEUDOEFETIVO 'Conte�do Realizado',
	SPA.OBSERVACAO 'Observa��o',
	SH.HORAINICIAL 'Hora inicial',
	SH.HORAFINAL 'Hora final',
	SHT.DATAINICIAL 'Data inicial', 
	SHT.DATAFINAL 'Data final',
	ST.NOME 'Turno', 
	CONVERT(VARCHAR,STD.DTINICIAL,103) 'Dt Inicial Turma', 
	CONVERT(VARCHAR,STD.DTFINAL,103) 'Dt Final Turma',
	SPL.CODPERLET 'Per. Letivo', 
	STD.CODTURMA 'CODTURMA', 
	STD.CODDISC 'Cod.Disciplina', 
	SD.NOME 'Disciplina',
	SC.NOME 'Curso'	
FROM 
	SHORARIOTURMA SHT (NOLOCK)
LEFT JOIN 
	SHORARIOPROFESSOR SHP (NOLOCK) ON 
	SHP.CODCOLIGADA    = SHT.CODCOLIGADA AND 
	SHP.IDHORARIOTURMA = SHT.IDHORARIOTURMA
INNER JOIN 
	SHORARIO SH (NOLOCK) ON 
	SHT.CODCOLIGADA = SH.CODCOLIGADA AND 
	SHT.CODHOR      = SH.CODHOR
INNER JOIN 
	STURNO ST (NOLOCK) ON 
	ST.CODCOLIGADA  = SH.CODCOLIGADA AND 
	ST.CODTURNO     = SH.CODTURNO
INNER JOIN 
	SPROFESSORTURMA SPT (NOLOCK) ON 
	SHP.CODCOLIGADA      = SPT.CODCOLIGADA AND 
	SHP.IDPROFESSORTURMA = SPT.IDPROFESSORTURMA
INNER JOIN 
	SPROFESSOR SP (NOLOCK) ON 
	SPT.CODCOLIGADA = SP.CODCOLIGADA AND 
	SPT.CODPROF     = SP.CODPROF
INNER JOIN 
	STURMADISC STD (NOLOCK) ON 
	STD.CODCOLIGADA = SHT.CODCOLIGADA AND 
	STD.IDTURMADISC = SHT.IDTURMADISC AND 
	STD.CODFILIAL   = SHT.CODFILIAL
INNER JOIN 
	SPLETIVO SPL (NOLOCK) ON 
	SPL.CODCOLIGADA = STD.CODCOLIGADA AND 
	SPL.CODFILIAL   = STD.CODFILIAL   AND 
	SPL.IDPERLET    = STD.IDPERLET					  
INNER JOIN 
	SHABILITACAOFILIAL SHF (NOLOCK) ON 
	SHF.CODCOLIGADA         = STD.CODCOLIGADA AND 
	SHF.IDHABILITACAOFILIAL = STD.IDHABILITACAOFILIAL
INNER JOIN 
	SDISCIPLINA SD (NOLOCK) ON 
	SD.CODCOLIGADA = STD.CODCOLIGADA AND 
	SD.CODDISC     = STD.CODDISC
INNER JOIN 
	SCURSO SC (NOLOCK) ON 
	SC.CODCOLIGADA = SHF.CODCOLIGADA AND 
	SC.CODCURSO    = SHF.CODCURSO
INNER JOIN PPESSOA PP (NOLOCK) ON 
	PP.CODIGO = SP.CODPESSOA
INNER JOIN 
	SPLANOAULA SPA (NOLOCK) ON
	SPA.CODCOLIGADA = SHT.CODCOLIGADA AND
	SPA.CODFILIAL   = SHT.CODFILIAL AND
	SPA.IDTURMADISC = SHT.IDTURMADISC AND
	SPA.IDHORARIOTURMA = SHT.IDHORARIOTURMA
WHERE
   SHT.CODCOLIGADA= 3
  --AND SHT.IDTURMADISC= '13086'
  AND SPT.CODPROF = '207'
  AND SHT.DATAINICIAL BETWEEN '2018-01-02' AND '2018-28-02'
 ) TAB