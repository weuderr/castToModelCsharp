namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_CONTROLADORIA
    {
        public int COD_ANALIS_CONTROL { get; set; }
        public int NUN_SEQ_CVTP { get; set; }
        public int COD_REVIS_CVTP { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REG_EMPRG { get; set; }
        public string COD_SIGLA_LOTAC { get; set; }
        public string E-MAIL_ANALIS_CUSTO { get; set; }
        public string PRODUT_SAP_SIMILAR { get; set; }
        public DateTime ANO_MES_REFER { get; set; }
        public int QTDE_AÇO_ANALCUSTO { get; set; }
        public string STATUS_ANALIS_CUSTO { get; set; }
        public DateTime DTH_INIC_ANALCUSTO { get; set; }
        public DateTime DTH_ENVIO_ANALCUSTO { get; set; }

        public virtual CVTP_PRODUTO CVTP_PRODUTO { get; set; }
    }
}