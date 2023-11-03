namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_REGRAS_FAROL
    {
        public int COD_REGRA_FAROL { get; set; }
        public string COD_AREA_NEGOCIO { get; set; }
        public int LIMIT_HORA_RETORNO { get; set; }
        public int PERC_LIMIT_AMARELO { get; set; }
        public DateTime DTH_CAD_REG { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REG_EMPRG { get; set; }
    }
}