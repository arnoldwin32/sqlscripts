SELECT 
CASE
WHEN DATEPART(WEEKDAY,DATEADD(d,5,GETDATE())) NOT IN (1,7) THEN 'DIA UTIL'
ELSE 'SD'
END AS 'NOVADATA'


