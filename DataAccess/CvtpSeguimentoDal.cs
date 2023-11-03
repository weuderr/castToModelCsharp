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
    public class CvtpSeguimentoDal
    {
        // Create CvtpSeguimento
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_SEGUIMENTO", values, "COD_SEG_CVTP");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_SEGUIMENTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpSeguimento
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_SEGUIMENTO", model, "COD_SEG_CVTP", model.COD_SEG_CVTP);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_SEGUIMENTO. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpSeguimento
        public CVTP_SEGUIMENTO GetById(int COD_SEG_CVTP, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SEGUIMENTO ");
                        strSql.Append(" WHERE COD_SEG_CVTP = " + COD_SEG_CVTP );
                        DataTable dtCvtpSeguimento = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_SEGUIMENTO model = new CVTP_SEGUIMENTO();

                        if (dtCvtpSeguimento.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_SEGUIMENTO>(dtCvtpSeguimento.Rows[0]);
                            
                        }
                        if(!string.IsNullOrEmpty(getRelations))
                        {
                            
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex) 
                {
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SEGUIMENTO com a query.", ex);
                }
            }
        
        // Read With Query CvtpSeguimento
        public List<CVTP_SEGUIMENTO> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_SEGUIMENTO ");
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
                        DataTable dtCvtpSeguimento = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_SEGUIMENTO> model = new List<CVTP_SEGUIMENTO>();
                        
                        if (dtCvtpSeguimento.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpSeguimento in dtCvtpSeguimento.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_SEGUIMENTO>(rowCvtpSeguimento);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_SEGUIMENTO com a query.", ex);
                }
            }

        // Delete CvtpSeguimento
        public int Delete(int COD_SEG_CVTP)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_SEGUIMENTO WHERE COD_SEG_CVTP = " + COD_SEG_CVTP;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_SEGUIMENTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}