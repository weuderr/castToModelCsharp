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
    public class CvtpSolicCustoDal
    {
        // Create CvtpSolicCusto
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_SOLIC_CUSTO", values, "COD_SOLIC_CUSTO");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_SOLIC_CUSTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpSolicCusto
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_SOLIC_CUSTO", model, "COD_SOLIC_CUSTO", model.COD_SOLIC_CUSTO);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_SOLIC_CUSTO. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpSolicCusto
        public CVTP_SOLIC_CUSTO GetById(int COD_SOLIC_CUSTO, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SOLIC_CUSTO ");
                        strSql.Append(" WHERE COD_SOLIC_CUSTO = " + COD_SOLIC_CUSTO );
                        DataTable dtCvtpSolicCusto = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_SOLIC_CUSTO model = new CVTP_SOLIC_CUSTO();

                        if (dtCvtpSolicCusto.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_SOLIC_CUSTO>(dtCvtpSolicCusto.Rows[0]);
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SOLIC_CUSTO com a query.", ex);
                }
            }
        
        // Read With Query CvtpSolicCusto
        public List<CVTP_SOLIC_CUSTO> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SOLIC_CUSTO ");
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
                        DataTable dtCvtpSolicCusto = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_SOLIC_CUSTO> model = new List<CVTP_SOLIC_CUSTO>();
                        
                        if (dtCvtpSolicCusto.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpSolicCusto in dtCvtpSolicCusto.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_SOLIC_CUSTO>(rowCvtpSolicCusto);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SOLIC_CUSTO com a query.", ex);
                }
            }

        // Delete CvtpSolicCusto
        public int Delete(int COD_SOLIC_CUSTO)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_SOLIC_CUSTO WHERE COD_SOLIC_CUSTO = " + COD_SOLIC_CUSTO;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_SOLIC_CUSTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}