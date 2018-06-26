SELECT  SLG.CODSTATUS
				FROM SLOGPLETIVO SLG (NOLOCK) 
				WHERE
					SLG.CODCOLIGADA 		= 3
				AND SLG.IDPERLET 			= 101
				AND SLG.CODFILIAL 			= 3
				AND SLG.CODTURMA 			= 'HTC-ATI-2-25' 
				AND SLG.IDHABILITACAOFILIAL = 4874
				AND SLG.RA 					= '0017687'
				AND SLG.CODSTATUS 		   != 1 
				AND SLG.DTALTERACAO 		= (SELECT MAX(SLP.DTALTERACAO) 
												FROM SLOGPLETIVO SLP
									   			WHERE	
									   				SLP.CODCOLIGADA 				= 3
									   			AND SLP.IDPERLET 					= 101 
												AND SLP.CODFILIAL					= 3
												AND SLP.CODTURMA 					= 'HTC-ATI-2-25' 
												AND SLP.IDHABILITACAOFILIAL 		= 4874
												AND SLP.RA 							= '0017687'
												AND CONVERT(DATE,SLP.DTALTERACAO) 	<= CONVERT(DATETIME,'2017-31-07'))