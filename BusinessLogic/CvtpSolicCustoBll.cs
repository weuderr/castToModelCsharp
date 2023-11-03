using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpSolicCustoBll
    {
        private readonly CvtpSolicCustoDal _CvtpSolicCustoDal;

        public CvtpSolicCustoBll()
        {
            _CvtpSolicCustoDal = new CvtpSolicCustoDal();
        }

        public CVTP_SOLIC_CUSTO GetCvtpSolicCustoById(int id, string getRelations = "")
        {
            return _CvtpSolicCustoDal.GetById(id, getRelations);
        }

        public List<CVTP_SOLIC_CUSTO> GetCvtpSolicCustoWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpSolicCustoDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpSolicCusto(dynamic entity)
        {
            return _CvtpSolicCustoDal.Insert(entity);
        }

        public int UpdateCvtpSolicCusto(dynamic entity)
        {
            return _CvtpSolicCustoDal.Update(entity);
        }

        public int DeleteCvtpSolicCusto(int id)
        {
            return _CvtpSolicCustoDal.Delete(id);
        }
    }
}