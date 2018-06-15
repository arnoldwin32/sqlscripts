private void codeActivity1_ExecuteCode(object sender, System.EventArgs args)
{
   
        var codcoligada    = this.DataSet.Tables[0].Rows[0]["CODCOLIGADA"].ToString();
        var codfilial      = this.DataSet.Tables[0].Rows[0]["CODFILIAL"].ToString();
        var codturma    = this.DataSet.Tables[0].Rows[0]["CODTURMA"].ToString();
        var idhabilitacaofilial = this.DataSet.Tables[0].Rows[0]["IDHABILITACAOFILIAL"].ToString();
		var idperlet = this.DataSet.Tables[0].Rows[0]["IDPERLET"].ToString();
		var datainicial = this.DataSet.Tables[0].Rows[0]["DTINICIAL"].ToString();
		var datafinal = this.DataSet.Tables[0].Rows[0]["DTFINAL"].ToString();
        AtualizarRegistro(this.DataSet,new object[]{codcoligada,codfilial,codturma,idhabilitacaofilial,idperlet,datainicial,datafinal},SqlUpdateCampos());
		//ExibirDadosDataSet(new object[]{codcoligada,codfilial,codturma,idhabilitacaofilial,idperlet,datainicial,datafinal);  
    
}
public System.Text.StringBuilder sql { get; set; }

public void AtualizarRegistro(System.Data.DataSet DS, object[] parametros, string sql)
{
            this.DBS.BeginTransaction();
            this.DBS.QueryExec(sql,parametros);
            this.DBS.Commit();
       
}

public string SqlUpdateCampos()
{
    System.Text.StringBuilder sql = new System.Text.StringBuilder();
    sql.AppendLine("UPDATE   SHABILITACAOALUNOCOMPL SET SHABILITACAOALUNOCOMPL.DATAINICIAL = :datainicial , SHABILITACAOALUNOCOMPL.DATAFINAL = :datafinal  FROM   SHABILITACAOALUNOCOMPL  INNER JOIN SHABILITACAOALUNO ON 	SHABILITACAOALUNO.CODCOLIGADA = SHABILITACAOALUNOCOMPL.CODCOLIGADA  AND SHABILITACAOALUNO.IDHABILITACAOFILIAL = SHABILITACAOALUNOCOMPL.IDHABILITACAOFILIAL  AND SHABILITACAOALUNO.RA = SHABILITACAOALUNOCOMPL.RA  INNER JOIN SMATRICPL ON 	SMATRICPL.CODCOLIGADA = SHABILITACAOALUNO.CODCOLIGADA  AND SMATRICPL.IDHABILITACAOFILIAL = SHABILITACAOALUNO.IDHABILITACAOFILIAL  AND SMATRICPL.RA = SHABILITACAOALUNO.RA  INNER JOIN STURMA ON  	STURMA.CODCOLIGADA = SMATRICPL.CODCOLIGADA  AND STURMA.CODFILIAL = SMATRICPL.CODFILIAL  AND STURMA.CODTURMA = SMATRICPL.CODTURMA  AND STURMA.IDPERLET = SMATRICPL.IDPERLET  WHERE       STURMA.CODTURMA    			= :codturma AND STURMA.CODFILIAL 			= :codfilial AND STURMA.CODCOLIGADA 			= :codcoligada AND STURMA.IDHABILITACAOFILIAL 	= :idhabilitacaofilial AND STURMA.IDPERLET = :idperlet \r\t");
    return sql.ToString();
}
public void Mensagem(string msg)
{
    throw new System.Exception(msg);
}

public void ExibirDadosDataSet(System.Data.DataSet DS)
{
            System.Text.StringBuilder txt = new System.Text.StringBuilder();
            for (int i = 0; i < DS.Tables.Count; i++)
            {
                txt.Append("Tabela: ");
                txt.AppendLine(DS.Tables[i].TableName.ToString());
                for (int l = 0; l < DS.Tables[i].Columns.Count; l++)
                {
                    txt.Append(DS.Tables[i].Columns[l].ColumnName.ToString());
                    txt.Append("\t");
                }
                txt.AppendLine();
                txt.AppendLine("---------------------------------------------------------------------------------------------");
                for (int j = 0; j < DS.Tables[i].Rows.Count; j++)
                {
                    for (int k = 0; k < DS.Tables[i].Columns.Count; k++)
                    {
                        txt.Append(DS.Tables[i].Rows[j][k].ToString());
                        txt.Append("\t");
                    }
                    txt.AppendLine();
                    txt.AppendLine("---------------------------------------------------------------------------------------------");
                }
            }

            Mensagem(txt.ToString());
 }