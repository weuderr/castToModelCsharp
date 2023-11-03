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
    public class CvtpControladoriaDal
    {
        // Create CvtpControladoria
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_CONTROLADORIA", values, "COD_ANALIS_CONTROL");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_CONTROLADORIA. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpControladoria
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_CONTROLADORIA", model, "COD_ANALIS_CONTROL", model.COD_ANALIS_CONTROL);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_CONTROLADORIA. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpControladoria
        public CVTP_CONTROLADORIA GetById(int COD_ANALIS_CONTROL, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_CONTROLADORIA ");
                        strSql.Append(" WHERE COD_ANALIS_CONTROL = " + COD_ANALIS_CONTROL );
                        DataTable dtCvtpControladoria = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_CONTROLADORIA model = new CVTP_CONTROLADORIA();

                        if (dtCvtpControladoria.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_CONTROLADORIA>(dtCvtpControladoria.Rows[0]);
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_CONTROLADORIA com a query.", ex);
                }
            }
        
        // Read With Query CvtpControladoria
        public List<CVTP_CONTROLADORIA> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_CONTROLADORIA ");
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
                        DataTable dtCvtpControladoria = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_CONTROLADORIA> model = new List<CVTP_CONTROLADORIA>();
                        
                        if (dtCvtpControladoria.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpControladoria in dtCvtpControladoria.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_CONTROLADORIA>(rowCvtpControladoria);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_CONTROLADORIA com a query.", ex);
                }
            }

        // Delete CvtpControladoria
        public int Delete(int COD_ANALIS_CONTROL)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_CONTROLADORIA WHERE COD_ANALIS_CONTROL = " + COD_ANALIS_CONTROL;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_CONTROLADORIA. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}