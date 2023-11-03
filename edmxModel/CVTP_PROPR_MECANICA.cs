namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_PROPR_MECANICA
    {
        public int NUN_PROP_MECAN { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public int COD_CONJ_PROP { get; set; }
        public decimal ESP_NOM_PRODT { get; set; }
        public decimal TOL_MIN_ESP { get; set; }
        public decimal TOL_MAX_ESP { get; set; }
        public decimal LAR_NOM_PRODT { get; set; }
        public decimal TOL_MIN_LAR { get; set; }
        public decimal TOL_MAX_LAR { get; set; }
        public int COMP_NOM_PRODT { get; set; }
        public int TOL_MIN_COMP { get; set; }
        public int TOL_MAX_COMP { get; set; }
        public string COD_TIPO_BORDA { get; set; }
        public DateTime DTH_CAD_REG { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REG_EMPRG { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}