namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_ANALIS_QUIMICA
    {
        public int COD_ELEM_QUIMICO { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public string COD_UNID_ELEM { get; set; }
        public decimal NUM_VLR_MIN { get; set; }
        public decimal NUM_VLR_MAX { get; set; }
        public DateTime? DTH_CAD_REG { get; set; }
        public int? COD_REG_USUAR { get; set; }
        public int? COD_REG_EMPRG { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}