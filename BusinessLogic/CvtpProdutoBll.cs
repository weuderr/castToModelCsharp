using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpProdutoBll
    {
        private readonly CvtpProdutoDal _CvtpProdutoDal;

        public CvtpProdutoBll()
        {
            _CvtpProdutoDal = new CvtpProdutoDal();
        }

        public CVTP_PRODUTO GetCvtpProdutoById(int id, string getRelations = "")
        {
            return _CvtpProdutoDal.GetById(id, getRelations);
        }

        public List<CVTP_PRODUTO> GetCvtpProdutoWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpProdutoDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpProduto(dynamic entity)
        {
            return _CvtpProdutoDal.Insert(entity);
        }

        public int UpdateCvtpProduto(dynamic entity)
        {
            return _CvtpProdutoDal.Update(entity);
        }

        public int DeleteCvtpProduto(int id)
        {
            return _CvtpProdutoDal.Delete(id);
        }
    }
}