using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpSolicAnaliseBll
    {
        private readonly CvtpSolicAnaliseDal _CvtpSolicAnaliseDal;

        public CvtpSolicAnaliseBll()
        {
            _CvtpSolicAnaliseDal = new CvtpSolicAnaliseDal();
        }

        public CVTP_SOLIC_ANALISE GetCvtpSolicAnaliseById(int id, string getRelations = "")
        {
            return _CvtpSolicAnaliseDal.GetById(id, getRelations);
        }

        public List<CVTP_SOLIC_ANALISE> GetCvtpSolicAnaliseWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpSolicAnaliseDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpSolicAnalise(dynamic entity)
        {
            return _CvtpSolicAnaliseDal.Insert(entity);
        }

        public int UpdateCvtpSolicAnalise(dynamic entity)
        {
            return _CvtpSolicAnaliseDal.Update(entity);
        }

        public int DeleteCvtpSolicAnalise(int id)
        {
            return _CvtpSolicAnaliseDal.Delete(id);
        }
    }
}