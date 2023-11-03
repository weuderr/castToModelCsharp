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
    public class CvtpProprMecanicaDal
    {
        // Create CvtpProprMecanica
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_PROPR_MECANICA", values, "NUN_PROP_MECAN");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_PROPR_MECANICA. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpProprMecanica
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_PROPR_MECANICA", model, "NUN_PROP_MECAN", model.NUN_PROP_MECAN);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_PROPR_MECANICA. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpProprMecanica
        public CVTP_PROPR_MECANICA GetById(int NUN_PROP_MECAN, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_PROPR_MECANICA ");
                        strSql.Append(" WHERE NUN_PROP_MECAN = " + NUN_PROP_MECAN );
                        DataTable dtCvtpProprMecanica = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_PROPR_MECANICA model = new CVTP_PROPR_MECANICA();

                        if (dtCvtpProprMecanica.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_PROPR_MECANICA>(dtCvtpProprMecanica.Rows[0]);
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_PROPR_MECANICA com a query.", ex);
                }
            }
        
        // Read With Query CvtpProprMecanica
        public List<CVTP_PROPR_MECANICA> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_PROPR_MECANICA ");
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
                        DataTable dtCvtpProprMecanica = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_PROPR_MECANICA> model = new List<CVTP_PROPR_MECANICA>();
                        
                        if (dtCvtpProprMecanica.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpProprMecanica in dtCvtpProprMecanica.Rows) {
                                
                                var values = Utils.MapDataRowToObject<CVTP_PROPR_MECANICA>(rowCvtpProprMecanica);

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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_PROPR_MECANICA com a query.", ex);
                }
            }

        // Delete CvtpProprMecanica
        public int Delete(int NUN_PROP_MECAN)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_PROPR_MECANICA WHERE NUN_PROP_MECAN = " + NUN_PROP_MECAN;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_PROPR_MECANICA. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}