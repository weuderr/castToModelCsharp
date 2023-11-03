using System.Collections.Generic;
using Aperam.PCP.PNV.DataAccess;
using Aperam.PCP.PNV.Negocio.Modelos;

namespace Aperam.PCP.PNV.BusinessLogic
{
    public class CvtpProprMecanicaBll
    {
        private readonly CvtpProprMecanicaDal _CvtpProprMecanicaDal;

        public CvtpProprMecanicaBll()
        {
            _CvtpProprMecanicaDal = new CvtpProprMecanicaDal();
        }

        public CVTP_PROPR_MECANICA GetCvtpProprMecanicaById(int id, string getRelations = "")
        {
            return _CvtpProprMecanicaDal.GetById(id, getRelations);
        }

        public List<CVTP_PROPR_MECANICA> GetCvtpProprMecanicaWithObject(object queryObj, string getRelations = "")
        {
            return _CvtpProprMecanicaDal.GetWithObject(queryObj, getRelations);
        }

        public int AddCvtpProprMecanica(dynamic entity)
        {
            return _CvtpProprMecanicaDal.Insert(entity);
        }

        public int UpdateCvtpProprMecanica(dynamic entity)
        {
            return _CvtpProprMecanicaDal.Update(entity);
        }

        public int DeleteCvtpProprMecanica(int id)
        {
            return _CvtpProprMecanicaDal.Delete(id);
        }
    }
}