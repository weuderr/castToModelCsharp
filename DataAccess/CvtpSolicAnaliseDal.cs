using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.ComponentModel;
using Aperam.PCP.PNV.BusinessLogic;
using Aperam.Biblioteca.DataBase;
using Aperam.PCP.PNV.Negocio.Base;
using Aperam.PCP.PNV.Negocio.Modelos;
using Oracle.DataAccess.Client;

namespace Aperam.PCP.PNV.DataAccess
{
    public class CvtpSolicAnaliseDal
    {
        // Create CvtpSolicAnalise
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_SOLIC_ANALISE", values, "COD_SOLIC_ANALISE");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_SOLIC_ANALISE. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpSolicAnalise
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_SOLIC_ANALISE", model, "COD_SOLIC_ANALISE", model.COD_SOLIC_ANALISE);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_SOLIC_ANALISE. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpSolicAnalise
        public CVTP_SOLIC_ANALISE GetById(int COD_SOLIC_ANALISE, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SOLIC_ANALISE ");
                        strSql.Append(" WHERE COD_SOLIC_ANALISE = " + COD_SOLIC_ANALISE );
                        DataTable dtCvtpSolicAnalise = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_SOLIC_ANALISE model = new CVTP_SOLIC_ANALISE();

                        if (dtCvtpSolicAnalise.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_SOLIC_ANALISE>(dtCvtpSolicAnalise.Rows[0]);
                            if(getRelations.Contains("CVTP_PRODUTO") && model.NUN_SEQ_CVTP != null) {
                                CVTP_PRODUTO rtCvtpProduto = new CvtpProdutoBll().GetCvtpProdutoById(model.NUN_SEQ_CVTP, getRelations);
                                if (rtCvtpProduto != null && rtCvtpProduto.NUN_SEQ_CVTP != null) {
                                    model.CVTP_PRODUTO = rtCvtpProduto;
                                }
                            }
                        }
                        if(!string.IsNullOrEmpty(getRelations))
                        {
                            
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex) 
                {
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SOLIC_ANALISE com a query.", ex);
                }
            }
        
        // Read With Query CvtpSolicAnalise
        public List<CVTP_SOLIC_ANALISE> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SOLIC_ANALISE ");
foreach (PropertyDescriptor property in TypeDescriptor.GetProperties(queryObj))
                        {
                            var value = property.GetValue(queryObj);
                            if (value != null)
                            {
                                string sanitizedValue = value.ToString().Replace("'", "''");
                                if(sqlWhere == "")
                                    sqlWhere = $" WHERE {property.Name} = '{sanitizedValue}'";
                                else
                                    sqlWhere += $" AND {property.Name} = '{sanitizedValue}'";
                            }
                        }
                        strSql.Append(sqlWhere);
                        DataTable dtCvtpSolicAnalise = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_SOLIC_ANALISE> model = new List<CVTP_SOLIC_ANALISE>();
                        
                        if (dtCvtpSolicAnalise.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpSolicAnalise in dtCvtpSolicAnalise.Rows) {
                                if (!rowCvtpSolicAnalise.Table.Columns.Contains("IDC_ANEXO_ANALISE"))
rowCvtpSolicAnalise.Table.Columns.Remove("IDC_ANEXO_ANALISE");
                                var values = Utils.MapDataRowToObject<CVTP_SOLIC_ANALISE>(rowCvtpSolicAnalise);

                                //Inicio da busca de relacionamentos
                                
                                model.Add(values);
                            }
                        } else {
                            return null;
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex)
                {
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SOLIC_ANALISE com a query.", ex);
                }
            }

        // Delete CvtpSolicAnalise
        public int Delete(int COD_SOLIC_ANALISE)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_SOLIC_ANALISE WHERE COD_SOLIC_ANALISE = " + COD_SOLIC_ANALISE;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_SOLIC_ANALISE. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}