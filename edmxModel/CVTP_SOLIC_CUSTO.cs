namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_SOLIC_CUSTO
    {
        public int COD_SOLIC_CUSTO { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public int COD_CLIENTE { get; set; }
        public string DESC_ACO_RVTP { get; set; }
        public string DESC_GRUPO_CVTP { get; set; }
        public string COD_ACAB_REVEST { get; set; }
        public string DETAL_DIMENS_ANALIS { get; set; }
        public int CUSTO_DIRETO_ABC { get; set; }
        public DateTime DTH_CAD_REG { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REG_EMPRG { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}