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
    public class CvtpControladoriaController : ControleBase
    {
        #region Propriedades
            String NomeExecutavel = String.Empty;
            CvtpControladoriaBll acessaDados = null;
            UtilsController utils = null;
        #endregion
        
        #region Construtor
            public CvtpControladoriaController()
            {
                this.NomeExecutavel = "PNMBI009";
                this.acessaDados = new CvtpControladoriaBll();
                this.utils = new UtilsController();
            }
        #endregion
        
        #region Verbos HTTP
        
            /// <summary>
            /// Método responsável por retornar os dados de CvtpControladoria
            /// </summary>
            /// <param name="cod_analis_control"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpGet]
            public JsonResult GetData(string cod_analis_control = "", string relations = "")
            {
                if (!string.IsNullOrEmpty(cod_analis_control))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_analis_control);
                        var lista = this.acessaDados.GetCvtpControladoriaById(value, relations);
                        
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
            /// Método responsável por retornar uma lista de CvtpControladoria
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
                            var lista = this.acessaDados.GetCvtpControladoriaWithObject(queryObj, relations);
                            
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
            /// Método responsável por salvar os dados de CvtpControladoria
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
                            var model = JsonConvert.DeserializeObject<CvtpControladoriaViewModel>(body);
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                            
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.AddCvtpControladoria(model);
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
            /// Método responsável por atualizar os dados de CvtpControladoria
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
                            var model = JsonConvert.DeserializeObject<CvtpControladoriaViewModel>(body);
                            
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                                
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.UpdateCvtpControladoria(model);
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
            /// Método responsável por deletar os dados de CvtpControladoria
            /// </summary>
            /// <param name="cod_analis_control"></param>
            /// <returns>JsonResult</returns>
            [HttpDelete]
            public JsonResult DeleteData(string cod_analis_control = "")
            {
                if (!string.IsNullOrEmpty(cod_analis_control))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_analis_control);
                        var success = this.acessaDados.DeleteCvtpControladoria(value);
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
    