private void Executar_ExecuteCode(object sender, System.EventArgs args)
{
   for(int f = 0; f < this.DataSet.Tables[0].Rows.Count; f++)
    {
        var codcoligada    = this.DataSet.Tables[0].Rows[f]["CODCOLIGADA"].ToString();
        var codfilial      = this.DataSet.Tables[0].Rows[f]["CODFILIAL"].ToString();
        var codturma    = this.DataSet.Tables[0].Rows[f]["CODTURMA"].ToString();
        var idhabilitacaofilial = this.DataSet.Tables[0].Rows[f]["IDHABILITACAOFILIAL"].ToString();
		var datainicial = this.DataSet.Tables[0].Rows[f]["DTINICIAL"].ToString();
		var datafinal = this.DataSet.Tables[0].Rows[f]["DTFINAL"].ToString();
        //throw new System.Exception(codcoligada.ToString() + '-' + idhorarioturma.ToString()+ '-' + codfilial.ToString() + '-' + idturmadisc.ToString());    
        AtualizarRegistro(this.DataSet,new object[]{codcoligada,codfilial,codturma,idhabilitacaofilial},SqlUpdateSala());
    //throw new System.Exception(codcoligada.ToString() + '-' + idhorarioturma.ToString()+ '-' + codfilial.ToString() + '-' + idturmadisc.ToString());    
    }
}
public System.Text.StringBuilder sql { get; set; }

public void AtualizarRegistro(System.Data.DataSet DS, object[] parametros, string sql)
{
            this.DBS.BeginTransaction();
            this.DBS.QueryExec(sql,parametros);
            this.DBS.Commit();
       
}

public string SqlUpdateSala()
{
    System.Text.StringBuilder sql = new System.Text.StringBuilder();
    sql.AppendLine("UPDATE SHORARIOTURMA SET CODTIPOSALA = '6' WHERE CODCOLIGADA = :codcoligada AND CODFILIAL = :codfilial AND IDTURMADISC = :idturmadisc AND IDHORARIOTURMA = :idhorarioturma \r\t");
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