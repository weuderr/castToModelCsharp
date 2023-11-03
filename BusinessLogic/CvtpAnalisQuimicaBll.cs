using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpAnalisQuimicaBll
    {
        private readonly CvtpAnalisQuimicaDal _CvtpAnalisQuimicaDal;

        public CvtpAnalisQuimicaBll()
        {
            _CvtpAnalisQuimicaDal = new CvtpAnalisQuimicaDal();
        }

        public CVTP_ANALIS_QUIMICA GetCvtpAnalisQuimicaById(int id, string getRelations = "")
        {
            return _CvtpAnalisQuimicaDal.GetById(id, getRelations);
        }

        public List<CVTP_ANALIS_QUIMICA> GetCvtpAnalisQuimicaWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpAnalisQuimicaDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpAnalisQuimica(dynamic entity)
        {
            return _CvtpAnalisQuimicaDal.Insert(entity);
        }

        public int UpdateCvtpAnalisQuimica(dynamic entity)
        {
            return _CvtpAnalisQuimicaDal.Update(entity);
        }

        public int DeleteCvtpAnalisQuimica(int id)
        {
            return _CvtpAnalisQuimicaDal.Delete(id);
        }
    }
}