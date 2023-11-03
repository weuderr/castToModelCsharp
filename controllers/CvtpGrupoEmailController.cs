using System;
using Aperam.Biblioteca.Util.Base.Entidades;
using Aperam.Biblioteca.Util.Base.MVC;
using System.Collections.Generic;
using System.IO;
using System.Web.Mvc;
using Aperam.PCP.PNV.BusinessLogic;
using Aperam.PCP.PNV.UI.ViewModels;
using Newtonsoft.Json;

namespace Aperam.PCP.PNV.UI.Controllers
{
    [HandleError]
    public class CvtpGrupoEmailController : ControleBase
    {
        #region Propriedades
            String NomeExecutavel = String.Empty;
            CvtpGrupoEmailBll acessaDados = null;
            UtilsController utils = null;
        #endregion
        
        #region Construtor
            public CvtpGrupoEmailController()
            {
                this.NomeExecutavel = "PNMBI009";
                this.acessaDados = new CvtpGrupoEmailBll();
                this.utils = new UtilsController();
            }
        #endregion
        
        #region Verbos HTTP
        
            /// <summary>
            /// Método responsável por retornar os dados de CvtpGrupoEmail
            /// </summary>
            /// <param name="cod_grupo_area"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpGet]
            public JsonResult GetData(string cod_grupo_area = "", string relations = "")
            {
                if (!string.IsNullOrEmpty(cod_grupo_area))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_grupo_area);
                        var lista = this.acessaDados.GetCvtpGrupoEmailById(value, relations);
                        
                        if(lista != null)
                        {
                            var castJson = JsonConvert.SerializeObject(lista);
                            return Json(new { success = true, data = castJson }, JsonRequestBehavior.AllowGet);
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                    }
                }
        
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
            
            /// <summary>
            /// Método responsável por retornar uma lista de CvtpGrupoEmail
            /// </summary>
            /// <param name="queryObj"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpPost]
            public JsonResult GetListDataWithObject()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var queryObj = JsonConvert.DeserializeObject(body);
                            string relations = "";
                            var lista = this.acessaDados.GetCvtpGrupoEmailWithObject(queryObj, relations);
                            
                            if(lista != null)
                            {
                                var castJson = JsonConvert.SerializeObject(lista);
                                return Json(new { success = true, data = castJson }, JsonRequestBehavior.AllowGet);
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                            
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
    
            /// <summary>
            /// Método responsável por salvar os dados de CvtpGrupoEmail
            /// </summary>
            /// <returns>JsonResult</returns>
            [HttpPost]
            public JsonResult CreateData()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var model = JsonConvert.DeserializeObject<CvtpGrupoEmailViewModel>(body);
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                            
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.AddCvtpGrupoEmail(model);
                            if(lista > 0)
                                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                
                return Json(new { success = false, message = "Erro ao inserir dados." }, JsonRequestBehavior.AllowGet);
            }
            
            /// <summary>
            /// Método responsável por atualizar os dados de CvtpGrupoEmail
            /// </summary>
            /// <returns>JsonResult</returns>
            [HttpPut]
            public JsonResult UpdateData()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var model = JsonConvert.DeserializeObject<CvtpGrupoEmailViewModel>(body);
                            
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                                
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.UpdateCvtpGrupoEmail(model);
                            if(lista > 0)
                                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
    
            /// <summary>
            /// Método responsável por deletar os dados de CvtpGrupoEmail
            /// </summary>
            /// <param name="cod_grupo_area"></param>
            /// <returns>JsonResult</returns>
            [HttpDelete]
            public JsonResult DeleteData(string cod_grupo_area = "")
            {
                if (!string.IsNullOrEmpty(cod_grupo_area))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_grupo_area);
                        var success = this.acessaDados.DeleteCvtpGrupoEmail(value);
                        return Json(new { success }, JsonRequestBehavior.AllowGet);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                    }
                }
        
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
        
        #endregion

        #region Métodos Herdados
        
            public override List<Acao> AcoesXGT
            {
                get { return new List<Acao>(); }
            }
    
            public override InformacoesXGT InformacoesXGT
            {
                get { return new InformacoesXGT { NomeExecutavel = this.NomeExecutavel }; }
            }
        
        #endregion
    }
}
    