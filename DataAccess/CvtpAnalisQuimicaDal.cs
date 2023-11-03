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
    public class CvtpAnalisQuimicaDal
    {
        // Create CvtpAnalisQuimica
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_ANALIS_QUIMICA", values, "COD_ELEM_QUIMICO");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_ANALIS_QUIMICA. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpAnalisQuimica
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_ANALIS_QUIMICA", model, "COD_ELEM_QUIMICO", model.COD_ELEM_QUIMICO);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_ANALIS_QUIMICA. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpAnalisQuimica
        public CVTP_ANALIS_QUIMICA GetById(int COD_ELEM_QUIMICO, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_ANALIS_QUIMICA ");
                        strSql.Append(" WHERE COD_ELEM_QUIMICO = " + COD_ELEM_QUIMICO );
                        DataTable dtCvtpAnalisQuimica = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_ANALIS_QUIMICA model = new CVTP_ANALIS_QUIMICA();

                        if (dtCvtpAnalisQuimica.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_ANALIS_QUIMICA>(dtCvtpAnalisQuimica.Rows[0]);
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_ANALIS_QUIMICA com a query.", ex);
                }
            }
        
        // Read With Query CvtpAnalisQuimica
        public List<CVTP_ANALIS_QUIMICA> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_ANALIS_QUIMICA ");
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
                        DataTable dtCvtpAnalisQuimica = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_ANALIS_QUIMICA> model = new List<CVTP_ANALIS_QUIMICA>();
                        
                        if (dtCvtpAnalisQuimica.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpAnalisQuimica in dtCvtpAnalisQuimica.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_ANALIS_QUIMICA>(rowCvtpAnalisQuimica);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_ANALIS_QUIMICA com a query.", ex);
                }
            }

        // Delete CvtpAnalisQuimica
        public int Delete(int COD_ELEM_QUIMICO)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_ANALIS_QUIMICA WHERE COD_ELEM_QUIMICO = " + COD_ELEM_QUIMICO;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_ANALIS_QUIMICA. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}