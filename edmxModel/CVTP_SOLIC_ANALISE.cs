namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_SOLIC_ANALISE
    {
        public int COD_SOLIC_ANALISE { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public string PROC_SOLIC_ANALIS { get; set; }
        public DateTime DHT_SOLIC_ANALISE { get; set; }
        public string EMAIL_ENVIO_ANALISE { get; set; }
        public string COD_AREA_SOLICIT { get; set; }
        public string EMAIL_DIREC_EMAIL { get; set; }
        public string DESC_DETAL_EMAIL { get; set; }
        public DateTime DTH_LIMITE_RETORN { get; set; }
        public int USUAR_SOLIC_ANALIS { get; set; }
        public int EMPRG_SOLIC_ANALIS { get; set; }
        public string DESC_ANALIS_EMAIL { get; set; }
        public DateTime DHT_RETORN_ANALISE { get; set; }
        public string IDC_ANEXO_ANALISE { get; set; }
        public int USUAR_RETOR_ANALIS { get; set; }
        public int EMPRG_RETOR_ANALIS { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}