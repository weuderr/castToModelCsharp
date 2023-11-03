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
    public class CvtpGrupoEmailDal
    {
        // Create CvtpGrupoEmail
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_GRUPO_EMAIL", values, "COD_GRUPO_AREA");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_GRUPO_EMAIL. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpGrupoEmail
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_GRUPO_EMAIL", model, "COD_GRUPO_AREA", model.COD_GRUPO_AREA);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_GRUPO_EMAIL. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpGrupoEmail
        public CVTP_GRUPO_EMAIL GetById(int COD_GRUPO_AREA, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_GRUPO_EMAIL ");
                        strSql.Append(" WHERE COD_GRUPO_AREA = " + COD_GRUPO_AREA );
                        DataTable dtCvtpGrupoEmail = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_GRUPO_EMAIL model = new CVTP_GRUPO_EMAIL();

                        if (dtCvtpGrupoEmail.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_GRUPO_EMAIL>(dtCvtpGrupoEmail.Rows[0]);
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_GRUPO_EMAIL com a query.", ex);
                }
            }
        
        // Read With Query CvtpGrupoEmail
        public List<CVTP_GRUPO_EMAIL> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_GRUPO_EMAIL ");
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
                        DataTable dtCvtpGrupoEmail = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_GRUPO_EMAIL> model = new List<CVTP_GRUPO_EMAIL>();
                        
                        if (dtCvtpGrupoEmail.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpGrupoEmail in dtCvtpGrupoEmail.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_GRUPO_EMAIL>(rowCvtpGrupoEmail);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_GRUPO_EMAIL com a query.", ex);
                }
            }

        // Delete CvtpGrupoEmail
        public int Delete(int COD_GRUPO_AREA)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_GRUPO_EMAIL WHERE COD_GRUPO_AREA = " + COD_GRUPO_AREA;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_GRUPO_EMAIL. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}