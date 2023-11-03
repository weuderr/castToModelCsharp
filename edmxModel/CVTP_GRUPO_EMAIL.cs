namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_GRUPO_EMAIL
    {
        public int COD_GRUPO_AREA { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public string SETOR_GRUPO_AREA { get; set; }
        public string DES_EMAIL_USUAR { get; set; }
        public DateTime DTH_CAD_REG { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REG_EMPRG { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}