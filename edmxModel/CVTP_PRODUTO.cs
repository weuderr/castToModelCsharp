namespace Aperam.PCP.PNV.Negocio.Modelos
{
    using System;
    using System.Collections.Generic;

    public partial class CVTP_PRODUTO
    {
        public CVTP_PRODUTO()
        {
            this.CVTP_ANALIS_QUIMICA = new HashSet<CVTP_ANALIS_QUIMICA>();
            this.CVTP_CONTROLADORIA = new HashSet<CVTP_CONTROLADORIA>();
            this.CVTP_GRUPO_EMAIL = new HashSet<CVTP_GRUPO_EMAIL>();
            this.CVTP_PROPR_MECANICA = new HashSet<CVTP_PROPR_MECANICA>();
            this.CVTP_SOLIC_ANALISE = new HashSet<CVTP_SOLIC_ANALISE>();
            this.CVTP_SOLIC_CUSTO = new HashSet<CVTP_SOLIC_CUSTO>();
        }

        public int NUN_SEQ_CVTP { get; set; }
        public int COD_CLIENTE { get; set; }
        public string DESC_TOLER_PROD { get; set; }
        public string DESC_PADRONIZ_ESP { get; set; }
        public string POS_BOB_TIRA { get; set; }
        public string COD_MERC_CVTP { get; set; }
        public string DESC_OUTRO_SEG { get; set; }
        public string COD_SITUA_CVTP { get; set; }
        public string COD_DIMENS_PROD { get; set; }
        public string COD_ENSAIO_LABOR { get; set; }
        public string COD_TIPO_PERDA { get; set; }
        public string DESC_COMP_QUIMICA { get; set; }
        public string DIAM_INTERN_BOB { get; set; }
        public string COD_NORM_CLIENTE { get; set; }
        public string ACO_INTERN_CVTP { get; set; }
        public string COD_ACAB_REVEST { get; set; }
        public string COD_AREA_APLIC { get; set; }
        public string COD_ARQUI_ANEXO { get; set; }
        public string COD_ARQUI_ANEXORVTP { get; set; }
        public int COD_CVTP_PAI { get; set; }
        public string COD_ENVIO_CUSTO { get; set; }
        public string COD_IDENT_ACOEX { get; set; }
        public string COD_IDENT_FMACO { get; set; }
        public string COD_LINHA_PRODT { get; set; }
        public int COD_REG_EMPRG { get; set; }
        public int COD_REG_USUAR { get; set; }
        public int COD_REVIS_CVTP { get; set; }
        public string COD_SEG_CVTP { get; set; }
        public string COD_SETOR_AUTOMOT { get; set; }
        public string COD_SITUA_RVTP { get; set; }
        public string COMPLEX_INDUST_RVTP { get; set; }
        public string DESC_ANALIS_RISCORVTP { get; set; }
        public string DESC_APLIC_CVTP { get; set; }
        public string DESC_COMPLEX_CVTP { get; set; }
        public string DESC_CONDIC_FORNRVTP { get; set; }
        public string DESC_GRUPO_CVTP { get; set; }
        public string DESC_IMPACT_RELEVRVTP { get; set; }
        public string DESC_INFORMAC_FORN { get; set; }
        public string DESC_MOTIV_CONSULTA { get; set; }
        public string DESC_NORMA_CLIENTE { get; set; }
        public int DESC_QTD_FORNEC { get; set; }
        public string DESC_RECUSA_CVTP { get; set; }
        public DateTime DTH_ANALIS_RVTP { get; set; }
        public DateTime DTH_CADAST_CVTP { get; set; }
        public DateTime DTH_CADAST_RVTP { get; set; }
        public DateTime DTH_ENVIO_RVTP { get; set; }
        public DateTime DTH_RECEB_CVTP { get; set; }
        public DateTime DTH_RECUSA_CVTP { get; set; }
        public string FLUXO_ROTIN_PRODRVTP { get; set; }
        public string IDC_CUSTO_PRVTP { get; set; }
        public string IDC_ENVIO_RVTP { get; set; }
        public string IDC_FLAG_RVTP { get; set; }
        public string IDC_FLUXO_ROTRVTP { get; set; }
        public string IDC_TIPO_FORNRVTP { get; set; }
        public string IMPACT_RELEV_PROCERVTP { get; set; }
        public decimal LIMIT_ESCDOIS_MAX { get; set; }
        public decimal LIMIT_ESCDOIS_MIN { get; set; }
        public string LIMIT_ESCDOIS_UNID { get; set; }
        public decimal LIMIT_ESCUM_MAX { get; set; }
        public decimal LIMIT_ESCUM_MIN { get; set; }
        public string LIMIT_ESCUM_UNID { get; set; }
        public decimal LIMIT_RES_MAX { get; set; }
        public decimal LIMIT_RES_MIN { get; set; }
        public string LIMIT_RES_UNID { get; set; }
        public string NORMA_REFER_CVTP { get; set; }
        public int PES_LIQUI_PROD { get; set; }
        public string PRODUT_SAP_SIMRVTP { get; set; }
        public int QTD_CONJ_DIMENS { get; set; }
        public decimal TAM_GRAO_MAX { get; set; }
        public decimal TAM_GRAO_MIN { get; set; }
        public string TAM_GRAO_UNID { get; set; }
        public int VALOR_WKG { get; set; }
        public int VLR_DIAM_ESPEC { get; set; }
        public decimal VLR_DUREZA_MAX { get; set; }
        public decimal VLR_DUREZA_MIN { get; set; }
        public decimal VLR_IMPACTO_MAX { get; set; }
        public decimal VLR_IMPACTO_MIN { get; set; }
        public string VLR_IMPACTO_UNID { get; set; }
        public string VLR_INDUC { get; set; }
        public decimal VLR_OUTRO_MAX { get; set; }
        public decimal VLR_OUTRO_MIN { get; set; }
        public string VLR_OUTRO_UNID { get; set; }
        public string VLR_OUTROS { get; set; }
        public decimal VLR_OXALICO_MAX { get; set; }
        public decimal VLR_OXALICO_MIN { get; set; }
        public string VLR_OXALICO_UNID { get; set; }
        public string VLR_UNID_DUREZA { get; set; }
        public decimal VRL_ALONG_MAX { get; set; }
        public decimal VRL_ALONG_MIN { get; set; }
        public string VRL_ALONG_UNID { get; set; }
        public string VRL_FREQUENCIA { get; set; }
        public string ESP_TOLER_CENTRADA { get; set; }
        public string ESP_TOLER_NEGATIVA { get; set; }
        public string ESP_TOLER_POSITIVA { get; set; }
        public string TIPO_PESO_BOB { get; set; }

        public virtual PR_CLIENTE PR_CLIENTE { get; set; }
            public virtual ICollection<CVTP_ANALIS_QUIMICA> CVTP_ANALIS_QUIMICA { get; set; }
        public virtual ICollection<CVTP_CONTROLADORIA> CVTP_CONTROLADORIA { get; set; }
        public virtual ICollection<CVTP_GRUPO_EMAIL> CVTP_GRUPO_EMAIL { get; set; }
        public virtual ICollection<CVTP_PROPR_MECANICA> CVTP_PROPR_MECANICA { get; set; }
        public virtual ICollection<CVTP_SOLIC_ANALISE> CVTP_SOLIC_ANALISE { get; set; }
        public virtual ICollection<CVTP_SOLIC_CUSTO> CVTP_SOLIC_CUSTO { get; set; }
    }
}