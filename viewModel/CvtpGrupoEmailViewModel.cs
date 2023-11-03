using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpGrupoEmailViewModel
    {
        public decimal COD_GRUPO_AREA { get; set; }

        public decimal? NUN_SEQ_CVTP { get; set; }

        [StringLength(20, ErrorMessage = "O campo  não pode ter mais de 20 caracteres.")]
        public string SETOR_GRUPO_AREA { get; set; }

        [StringLength(50, ErrorMessage = "O campo  não pode ter mais de 50 caracteres.")]
        public string DES_EMAIL_USUAR { get; set; }

        public DateTime? DTH_CAD_REG { get; set; }

        public decimal? COD_REG_USUAR { get; set; }

        public decimal? COD_REG_EMPRG { get; set; }

    }
}