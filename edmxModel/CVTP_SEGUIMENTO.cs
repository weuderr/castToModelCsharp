namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_SEGUIMENTO
    {
        public int COD_SEG_CVTP { get; set; }
        public string DESC_SEGUIMENTO { get; set; }
        public DateTime? DTH_CAD_REG { get; set; }
        public int? COD_REG_USUAR { get; set; }
        public int? COD_REG_EMPRG { get; set; }
    }
}