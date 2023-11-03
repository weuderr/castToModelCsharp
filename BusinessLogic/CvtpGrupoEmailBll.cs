using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpGrupoEmailBll
    {
        private readonly CvtpGrupoEmailDal _CvtpGrupoEmailDal;

        public CvtpGrupoEmailBll()
        {
            _CvtpGrupoEmailDal = new CvtpGrupoEmailDal();
        }

        public CVTP_GRUPO_EMAIL GetCvtpGrupoEmailById(int id, string getRelations = "")
        {
            return _CvtpGrupoEmailDal.GetById(id, getRelations);
        }

        public List<CVTP_GRUPO_EMAIL> GetCvtpGrupoEmailWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpGrupoEmailDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpGrupoEmail(dynamic entity)
        {
            return _CvtpGrupoEmailDal.Insert(entity);
        }

        public int UpdateCvtpGrupoEmail(dynamic entity)
        {
            return _CvtpGrupoEmailDal.Update(entity);
        }

        public int DeleteCvtpGrupoEmail(int id)
        {
            return _CvtpGrupoEmailDal.Delete(id);
        }
    }
}