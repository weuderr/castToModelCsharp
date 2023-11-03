using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpControladoriaBll
    {
        private readonly CvtpControladoriaDal _CvtpControladoriaDal;

        public CvtpControladoriaBll()
        {
            _CvtpControladoriaDal = new CvtpControladoriaDal();
        }

        public CVTP_CONTROLADORIA GetCvtpControladoriaById(int id, string getRelations = "")
        {
            return _CvtpControladoriaDal.GetById(id, getRelations);
        }

        public List<CVTP_CONTROLADORIA> GetCvtpControladoriaWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpControladoriaDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpControladoria(dynamic entity)
        {
            return _CvtpControladoriaDal.Insert(entity);
        }

        public int UpdateCvtpControladoria(dynamic entity)
        {
            return _CvtpControladoriaDal.Update(entity);
        }

        public int DeleteCvtpControladoria(int id)
        {
            return _CvtpControladoriaDal.Delete(id);
        }
    }
}