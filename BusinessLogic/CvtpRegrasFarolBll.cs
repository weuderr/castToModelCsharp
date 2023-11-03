using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpRegrasFarolBll
    {
        private readonly CvtpRegrasFarolDal _CvtpRegrasFarolDal;

        public CvtpRegrasFarolBll()
        {
            _CvtpRegrasFarolDal = new CvtpRegrasFarolDal();
        }

        public CVTP_REGRAS_FAROL GetCvtpRegrasFarolById(int id, string getRelations = "")
        {
            return _CvtpRegrasFarolDal.GetById(id, getRelations);
        }

        public List<CVTP_REGRAS_FAROL> GetCvtpRegrasFarolWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpRegrasFarolDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpRegrasFarol(dynamic entity)
        {
            return _CvtpRegrasFarolDal.Insert(entity);
        }

        public int UpdateCvtpRegrasFarol(dynamic entity)
        {
            return _CvtpRegrasFarolDal.Update(entity);
        }

        public int DeleteCvtpRegrasFarol(int id)
        {
            return _CvtpRegrasFarolDal.Delete(id);
        }
    }
}