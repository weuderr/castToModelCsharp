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
    public class CvtpProdutoDal
    {
        // Create CvtpProduto
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("CVTP_PRODUTO", values, "NUN_SEQ_CVTP");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela CVTP_PRODUTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update CvtpProduto
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("CVTP_PRODUTO", model, "NUN_SEQ_CVTP", model.NUN_SEQ_CVTP);
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela CVTP_PRODUTO. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read CvtpProduto
        public CVTP_PRODUTO GetById(int NUN_SEQ_CVTP, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_PRODUTO ");
                        strSql.Append(" WHERE NUN_SEQ_CVTP = " + NUN_SEQ_CVTP );
                        DataTable dtCvtpProduto = acessoDados.ExecuteDatatable( strSql.ToString() );
                        CVTP_PRODUTO model = new CVTP_PRODUTO();

                        if (dtCvtpProduto.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<CVTP_PRODUTO>(dtCvtpProduto.Rows[0]);
                            if(getRelations.Contains("PR_CLIENTE") && model.COD_CLIENTE != null) {
                                PR_CLIENTE rtPrCliente = new PrClienteBll().GetPrClienteById(model.COD_CLIENTE, getRelations);
                                if (rtPrCliente != null && rtPrCliente.COD_CLIENTE != null) {
                                    model.PR_CLIENTE = rtPrCliente;
                                }
                            }
                        }
                        if(!string.IsNullOrEmpty(getRelations))
                        {
                            

                        if(getRelations.Contains("CVTP_ANALIS_QUIMICA") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpAnalisQuimica = "SELECT * FROM CVTP_ANALIS_QUIMICA";
                            sqlCvtpAnalisQuimica += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpAnalisQuimica = acessoDados.ExecuteDatatable(sqlCvtpAnalisQuimica);
                            
                            if (dtCvtpAnalisQuimica != null && dtCvtpAnalisQuimica.Rows.Count > 0) {
                                var list = new List<CVTP_ANALIS_QUIMICA>();
                                foreach (DataRow row in dtCvtpAnalisQuimica.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_ANALIS_QUIMICA>(row);
                                    list.Add(item);
                                }
                                model.CVTP_ANALIS_QUIMICA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_CONTROLADORIA") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpControladoria = "SELECT * FROM CVTP_CONTROLADORIA";
                            sqlCvtpControladoria += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpControladoria = acessoDados.ExecuteDatatable(sqlCvtpControladoria);
                            
                            if (dtCvtpControladoria != null && dtCvtpControladoria.Rows.Count > 0) {
                                var list = new List<CVTP_CONTROLADORIA>();
                                foreach (DataRow row in dtCvtpControladoria.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_CONTROLADORIA>(row);
                                    list.Add(item);
                                }
                                model.CVTP_CONTROLADORIA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_GRUPO_EMAIL") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpGrupoEmail = "SELECT * FROM CVTP_GRUPO_EMAIL";
                            sqlCvtpGrupoEmail += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpGrupoEmail = acessoDados.ExecuteDatatable(sqlCvtpGrupoEmail);
                            
                            if (dtCvtpGrupoEmail != null && dtCvtpGrupoEmail.Rows.Count > 0) {
                                var list = new List<CVTP_GRUPO_EMAIL>();
                                foreach (DataRow row in dtCvtpGrupoEmail.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_GRUPO_EMAIL>(row);
                                    list.Add(item);
                                }
                                model.CVTP_GRUPO_EMAIL = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_PROPR_MECANICA") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpProprMecanica = "SELECT * FROM CVTP_PROPR_MECANICA";
                            sqlCvtpProprMecanica += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpProprMecanica = acessoDados.ExecuteDatatable(sqlCvtpProprMecanica);
                            
                            if (dtCvtpProprMecanica != null && dtCvtpProprMecanica.Rows.Count > 0) {
                                var list = new List<CVTP_PROPR_MECANICA>();
                                foreach (DataRow row in dtCvtpProprMecanica.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_PROPR_MECANICA>(row);
                                    list.Add(item);
                                }
                                model.CVTP_PROPR_MECANICA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_SOLIC_ANALISE") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpSolicAnalise = "SELECT * FROM CVTP_SOLIC_ANALISE";
                            sqlCvtpSolicAnalise += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpSolicAnalise = acessoDados.ExecuteDatatable(sqlCvtpSolicAnalise);
                            
                            if (dtCvtpSolicAnalise != null && dtCvtpSolicAnalise.Rows.Count > 0) {
                                var list = new List<CVTP_SOLIC_ANALISE>();
                                foreach (DataRow row in dtCvtpSolicAnalise.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_SOLIC_ANALISE>(row);
                                    list.Add(item);
                                }
                                model.CVTP_SOLIC_ANALISE = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_SOLIC_CUSTO") && model != null && model.NUN_SEQ_CVTP != null) {
                            string sqlCvtpSolicCusto = "SELECT * FROM CVTP_SOLIC_CUSTO";
                            sqlCvtpSolicCusto += " WHERE NUN_SEQ_CVTP = " + model.NUN_SEQ_CVTP;
                            DataTable dtCvtpSolicCusto = acessoDados.ExecuteDatatable(sqlCvtpSolicCusto);
                            
                            if (dtCvtpSolicCusto != null && dtCvtpSolicCusto.Rows.Count > 0) {
                                var list = new List<CVTP_SOLIC_CUSTO>();
                                foreach (DataRow row in dtCvtpSolicCusto.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_SOLIC_CUSTO>(row);
                                    list.Add(item);
                                }
                                model.CVTP_SOLIC_CUSTO = list;
                            }
                        }
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex) 
                {
                    throw new Exception("Erro ao buscar dados na tabela CVTP_PRODUTO com a query.", ex);
                }
            }
        
        // Read With Query CvtpProduto
        public List<CVTP_PRODUTO> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        strSql.Append(" SELECT * ");
                        strSql.Append(" FROM CVTP_PRODUTO ");
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
                        DataTable dtCvtpProduto = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<CVTP_PRODUTO> model = new List<CVTP_PRODUTO>();
                        
                        if (dtCvtpProduto.Rows.Count > 0 ) {
                            foreach (DataRow rowCvtpProduto in dtCvtpProduto.Rows) {
                                if (!rowCvtpProduto.Table.Columns.Contains("COD_ARQUI_ANEXO"))
rowCvtpProduto.Table.Columns.Remove("COD_ARQUI_ANEXO");
if (!rowCvtpProduto.Table.Columns.Contains("COD_ARQUI_ANEXORVTP"))
rowCvtpProduto.Table.Columns.Remove("COD_ARQUI_ANEXORVTP");
                                var values = Utils.MapDataRowToObject<CVTP_PRODUTO>(rowCvtpProduto);

                                //Inicio da busca de relacionamentos
                                

                        if(getRelations.Contains("CVTP_ANALIS_QUIMICA") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpAnalisQuimica = "SELECT * FROM CVTP_ANALIS_QUIMICA";
                            sqlCvtpAnalisQuimica += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpAnalisQuimica = acessoDados.ExecuteDatatable(sqlCvtpAnalisQuimica);
                            
                            if (dtCvtpAnalisQuimica != null && dtCvtpAnalisQuimica.Rows.Count > 0) {
                                var list = new List<CVTP_ANALIS_QUIMICA>();
                                foreach (DataRow row in dtCvtpAnalisQuimica.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_ANALIS_QUIMICA>(row);
                                    list.Add(item);
                                }
                                values.CVTP_ANALIS_QUIMICA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_CONTROLADORIA") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpControladoria = "SELECT * FROM CVTP_CONTROLADORIA";
                            sqlCvtpControladoria += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpControladoria = acessoDados.ExecuteDatatable(sqlCvtpControladoria);
                            
                            if (dtCvtpControladoria != null && dtCvtpControladoria.Rows.Count > 0) {
                                var list = new List<CVTP_CONTROLADORIA>();
                                foreach (DataRow row in dtCvtpControladoria.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_CONTROLADORIA>(row);
                                    list.Add(item);
                                }
                                values.CVTP_CONTROLADORIA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_GRUPO_EMAIL") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpGrupoEmail = "SELECT * FROM CVTP_GRUPO_EMAIL";
                            sqlCvtpGrupoEmail += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpGrupoEmail = acessoDados.ExecuteDatatable(sqlCvtpGrupoEmail);
                            
                            if (dtCvtpGrupoEmail != null && dtCvtpGrupoEmail.Rows.Count > 0) {
                                var list = new List<CVTP_GRUPO_EMAIL>();
                                foreach (DataRow row in dtCvtpGrupoEmail.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_GRUPO_EMAIL>(row);
                                    list.Add(item);
                                }
                                values.CVTP_GRUPO_EMAIL = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_PROPR_MECANICA") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpProprMecanica = "SELECT * FROM CVTP_PROPR_MECANICA";
                            sqlCvtpProprMecanica += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpProprMecanica = acessoDados.ExecuteDatatable(sqlCvtpProprMecanica);
                            
                            if (dtCvtpProprMecanica != null && dtCvtpProprMecanica.Rows.Count > 0) {
                                var list = new List<CVTP_PROPR_MECANICA>();
                                foreach (DataRow row in dtCvtpProprMecanica.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_PROPR_MECANICA>(row);
                                    list.Add(item);
                                }
                                values.CVTP_PROPR_MECANICA = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_SOLIC_ANALISE") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpSolicAnalise = "SELECT * FROM CVTP_SOLIC_ANALISE";
                            sqlCvtpSolicAnalise += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpSolicAnalise = acessoDados.ExecuteDatatable(sqlCvtpSolicAnalise);
                            
                            if (dtCvtpSolicAnalise != null && dtCvtpSolicAnalise.Rows.Count > 0) {
                                var list = new List<CVTP_SOLIC_ANALISE>();
                                foreach (DataRow row in dtCvtpSolicAnalise.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_SOLIC_ANALISE>(row);
                                    list.Add(item);
                                }
                                values.CVTP_SOLIC_ANALISE = list;
                            }
                        } 

                        if(getRelations.Contains("CVTP_SOLIC_CUSTO") && values != null && values.NUN_SEQ_CVTP != null) {
                            string sqlCvtpSolicCusto = "SELECT * FROM CVTP_SOLIC_CUSTO";
                            sqlCvtpSolicCusto += " WHERE NUN_SEQ_CVTP = " + values.NUN_SEQ_CVTP;
                            DataTable dtCvtpSolicCusto = acessoDados.ExecuteDatatable(sqlCvtpSolicCusto);
                            
                            if (dtCvtpSolicCusto != null && dtCvtpSolicCusto.Rows.Count > 0) {
                                var list = new List<CVTP_SOLIC_CUSTO>();
                                foreach (DataRow row in dtCvtpSolicCusto.Rows) {
                                    var item = Utils.MapDataRowToObject<CVTP_SOLIC_CUSTO>(row);
                                    list.Add(item);
                                }
                                values.CVTP_SOLIC_CUSTO = list;
                            }
                        }
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
                    throw new Exception("Erro ao buscar dados na tabela CVTP_PRODUTO com a query.", ex);
                }
            }

        // Delete CvtpProduto
        public int Delete(int NUN_SEQ_CVTP)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM CVTP_PRODUTO WHERE NUN_SEQ_CVTP = " + NUN_SEQ_CVTP;
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela CVTP_PRODUTO. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}