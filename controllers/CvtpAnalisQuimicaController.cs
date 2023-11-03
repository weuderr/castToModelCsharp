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
    public class CvtpAnalisQuimicaController : ControleBase
    {
        #region Propriedades
            String NomeExecutavel = String.Empty;
            CvtpAnalisQuimicaBll acessaDados = null;
            UtilsController utils = null;
        #endregion
        
        #region Construtor
            public CvtpAnalisQuimicaController()
            {
                this.NomeExecutavel = "PNMBI009";
                this.acessaDados = new CvtpAnalisQuimicaBll();
                this.utils = new UtilsController();
            }
        #endregion
        
        #region Verbos HTTP
        
            /// <summary>
            /// Método responsável por retornar os dados de CvtpAnalisQuimica
            /// </summary>
            /// <param name="cod_elem_quimico"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpGet]
            public JsonResult GetData(string cod_elem_quimico = "", string relations = "")
            {
                if (!string.IsNullOrEmpty(cod_elem_quimico))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_elem_quimico);
                        var lista = this.acessaDados.GetCvtpAnalisQuimicaById(value, relations);
                        
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
            /// Método responsável por retornar uma lista de CvtpAnalisQuimica
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
                            var lista = this.acessaDados.GetCvtpAnalisQuimicaWithObject(queryObj, relations);
                            
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
            /// Método responsável por salvar os dados de CvtpAnalisQuimica
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
                            var model = JsonConvert.DeserializeObject<CvtpAnalisQuimicaViewModel>(body);
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                            
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.AddCvtpAnalisQuimica(model);
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
            /// Método responsável por atualizar os dados de CvtpAnalisQuimica
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
                            var model = JsonConvert.DeserializeObject<CvtpAnalisQuimicaViewModel>(body);
                            
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                                
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.UpdateCvtpAnalisQuimica(model);
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
            /// Método responsável por deletar os dados de CvtpAnalisQuimica
            /// </summary>
            /// <param name="cod_elem_quimico"></param>
            /// <returns>JsonResult</returns>
            [HttpDelete]
            public JsonResult DeleteData(string cod_elem_quimico = "")
            {
                if (!string.IsNullOrEmpty(cod_elem_quimico))
                {
                    try
                    {
                        var value = Convert.ToInt32(cod_elem_quimico);
                        var success = this.acessaDados.DeleteCvtpAnalisQuimica(value);
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
    