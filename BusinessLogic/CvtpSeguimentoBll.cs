using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpSeguimentoBll
    {
        private readonly CvtpSeguimentoDal _CvtpSeguimentoDal;

        public CvtpSeguimentoBll()
        {
            _CvtpSeguimentoDal = new CvtpSeguimentoDal();
        }

        public CVTP_SEGUIMENTO GetCvtpSeguimentoById(int id, string getRelations = "")
        {
            return _CvtpSeguimentoDal.GetById(id, getRelations);
        }

        public List<CVTP_SEGUIMENTO> GetCvtpSeguimentoWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpSeguimentoDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpSeguimento(dynamic entity)
        {
            return _CvtpSeguimentoDal.Insert(entity);
        }

        public int UpdateCvtpSeguimento(dynamic entity)
        {
            return _CvtpSeguimentoDal.Update(entity);
        }

        public int DeleteCvtpSeguimento(int id)
        {
            return _CvtpSeguimentoDal.Delete(id);
        }
    }
}