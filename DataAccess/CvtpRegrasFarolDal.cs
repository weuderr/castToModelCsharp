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
    public class CvtpRegrasFarolDal
    {
        // Create CvtpRegrasFarol
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_REGRAS_FAROL", values, "COD_REGRA_FAROL");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_REGRAS_FAROL. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpRegrasFarol
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_REGRAS_FAROL", model, "COD_REGRA_FAROL", model.COD_REGRA_FAROL);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_REGRAS_FAROL. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpRegrasFarol
        public CVTP_REGRAS_FAROL GetById(int COD_REGRA_FAROL, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_REGRAS_FAROL ");
                        strSql.Append(" WHERE COD_REGRA_FAROL = " + COD_REGRA_FAROL );
                        DataTable dtCvtpRegrasFarol = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_REGRAS_FAROL model = new CVTP_REGRAS_FAROL();

                        if (dtCvtpRegrasFarol.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_REGRAS_FAROL>(dtCvtpRegrasFarol.Rows[0]);
                            
                        }
                        if(!string.IsNullOrEmpty(getRelations))
                        {
                            
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex) 
                {
                    throw new Exception("Erro ao buscar dados na tabela CVTP_REGRAS_FAROL com a query.", ex);
                }
            }
        
        // Read With Query CvtpRegrasFarol
        public List<CVTP_REGRAS_FAROL> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_REGRAS_FAROL ");
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
                        DataTable dtCvtpRegrasFarol = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_REGRAS_FAROL> model = new List<CVTP_REGRAS_FAROL>();
                        
                        if (dtCvtpRegrasFarol.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpRegrasFarol in dtCvtpRegrasFarol.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_REGRAS_FAROL>(rowCvtpRegrasFarol);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_REGRAS_FAROL com a query.", ex);
                }
            }

        // Delete CvtpRegrasFarol
        public int Delete(int COD_REGRA_FAROL)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_REGRAS_FAROL WHERE COD_REGRA_FAROL = " + COD_REGRA_FAROL;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_REGRAS_FAROL. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}