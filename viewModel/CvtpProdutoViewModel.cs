using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpProdutoViewModel
    {
        [Display(Name = "Sequência")]
        public decimal NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Cliente")]
        public decimal? COD_CLIENTE { get; set; }

        [Display(Name = "Tolerância do Produto")]
        [RegularExpression("^([AP,E])+$", ErrorMessage = "O campo Tolerância do Produto deve conter um dos seguintes valores: (A,P,E)")]        [StringLength(1, ErrorMessage = "O campo Tolerância do Produto não pode ter mais de 1 caracteres.")]
        public string DESC_TOLER_PROD { get; set; }

        [Display(Name = "Padronização Específica")]
        [RegularExpression("^([CN,P])+$", ErrorMessage = "O campo Padronização Específica deve conter um dos seguintes valores: (C,N,P)")]        [StringLength(1, ErrorMessage = "O campo Padronização Específica não pode ter mais de 1 caracteres.")]
        public string DESC_PADRONIZ_ESP { get; set; }

        [Display(Name = "Posição da Bobina/Tira")]
        [RegularExpression("^([HV])+$", ErrorMessage = "O campo Posição da Bobina/Tira deve conter um dos seguintes valores: (H,V)")]        [StringLength(1, ErrorMessage = "O campo Posição da Bobina/Tira não pode ter mais de 1 caracteres.")]
        public string POS_BOB_TIRA { get; set; }

        [Display(Name = "Mercado")]
        [RegularExpression("^([MIME])+$", ErrorMessage = "O campo Mercado deve conter um dos seguintes valores: (MI,ME)")]        [StringLength(2, ErrorMessage = "O campo Mercado não pode ter mais de 2 caracteres.")]
        public string COD_MERC_CVTP { get; set; }

        [Display(Name = "Descrição de Outro Segmento")]
        [StringLength(24, ErrorMessage = "O campo Descrição de Outro Segmento não pode ter mais de 24 caracteres.")]
        public string DESC_OUTRO_SEG { get; set; }

        [Display(Name = "Situação")]
        [RegularExpression("^([NVRB,PR,RC,CC,CA])+$", ErrorMessage = "O campo Situação deve conter um dos seguintes valores: (NV,RB,PR,RC,CC,CA)")]        [StringLength(2, ErrorMessage = "O campo Situação não pode ter mais de 2 caracteres.")]
        public string COD_SITUA_CVTP { get; set; }

        [Display(Name = "Dimensão do Produto")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Dimensão do Produto deve conter um dos seguintes valores: (P,E)")]        [StringLength(1, ErrorMessage = "O campo Dimensão do Produto não pode ter mais de 1 caracteres.")]
        public string COD_DIMENS_PROD { get; set; }

        [Display(Name = "Ensaio de Laboratório")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Ensaio de Laboratório deve conter um dos seguintes valores: (P,E)")]        [StringLength(1, ErrorMessage = "O campo Ensaio de Laboratório não pode ter mais de 1 caracteres.")]
        public string COD_ENSAIO_LABOR { get; set; }

        [Display(Name = "Tipo de Perda")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Tipo de Perda deve conter um dos seguintes valores: (P,E)")]        [StringLength(1, ErrorMessage = "O campo Tipo de Perda não pode ter mais de 1 caracteres.")]
        public string COD_TIPO_PERDA { get; set; }

        [Display(Name = "Composição Química")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Composição Química deve conter um dos seguintes valores: (P,E)")]        [StringLength(1, ErrorMessage = "O campo Composição Química não pode ter mais de 1 caracteres.")]
        public string DESC_COMP_QUIMICA { get; set; }

        [Display(Name = "Diâmetro Interno da Bobina")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Diâmetro Interno da Bobina deve conter um dos seguintes valores: (P,E)")]        [StringLength(1, ErrorMessage = "O campo Diâmetro Interno da Bobina não pode ter mais de 1 caracteres.")]
        public string DIAM_INTERN_BOB { get; set; }

        [Display(Name = "Norma do Cliente")]
        [RegularExpression("^([SN])+$", ErrorMessage = "O campo Norma do Cliente deve conter um dos seguintes valores: (S,N)")]        [StringLength(1, ErrorMessage = "O campo Norma do Cliente não pode ter mais de 1 caracteres.")]
        public string COD_NORM_CLIENTE { get; set; }

        [Display(Name = "Aço Interno")]
        [StringLength(24, ErrorMessage = "O campo Aço Interno não pode ter mais de 24 caracteres.")]
        public string ACO_INTERN_CVTP { get; set; }

        [Display(Name = "Acabamento e Revestimento")]
        [RegularExpression("^([PE])+$", ErrorMessage = "O campo Acabamento e Revestimento deve conter um dos seguintes valores: (P,E)")]        [StringLength(2, ErrorMessage = "O campo Acabamento e Revestimento não pode ter mais de 2 caracteres.")]
        public string COD_ACAB_REVEST { get; set; }

        [Display(Name = "Área de Aplicação")]
        [StringLength(1, ErrorMessage = "O campo Área de Aplicação não pode ter mais de 1 caracteres.")]
        public string COD_AREA_APLIC { get; set; }

        [Display(Name = "Anexo CVTP")]
        public string COD_ARQUI_ANEXO { get; set; }

        [Display(Name = "Anexo RVTP")]
        public string COD_ARQUI_ANEXORVTP { get; set; }

        [Display(Name = "Código Pai CVT")]
        public decimal? COD_CVTP_PAI { get; set; }

        [Display(Name = "Custo de Envio")]
        [RegularExpression("^([SN])+$", ErrorMessage = "O campo Custo de Envio deve conter um dos seguintes valores: (S,N)")]        [StringLength(1, ErrorMessage = "O campo Custo de Envio não pode ter mais de 1 caracteres.")]
        public string COD_ENVIO_CUSTO { get; set; }

        [Display(Name = "Identificação Aço Externo")]
        [StringLength(5, ErrorMessage = "O campo Identificação Aço Externo não pode ter mais de 5 caracteres.")]
        public string COD_IDENT_ACOEX { get; set; }

        [Display(Name = "Identificação FM Aço")]
        [StringLength(5, ErrorMessage = "O campo Identificação FM Aço não pode ter mais de 5 caracteres.")]
        public string COD_IDENT_FMACO { get; set; }

        [Display(Name = "Linha de Produto")]
        [StringLength(1, ErrorMessage = "O campo Linha de Produto não pode ter mais de 1 caracteres.")]
        public string COD_LINHA_PRODT { get; set; }

        [Display(Name = "Empregado Registrado")]
        public decimal? COD_REG_EMPRG { get; set; }

        [Display(Name = "Usuário Registrado")]
        public decimal? COD_REG_USUAR { get; set; }

        [Display(Name = "Revisão")]
        public decimal? COD_REVIS_CVTP { get; set; }

        [Display(Name = "Segmento")]
        [StringLength(24, ErrorMessage = "O campo Segmento não pode ter mais de 24 caracteres.")]
        public string COD_SEG_CVTP { get; set; }

        [Display(Name = "Setor Automotivo")]
        [RegularExpression("^([SN])+$", ErrorMessage = "O campo Setor Automotivo deve conter um dos seguintes valores: (S,N)")]        [StringLength(1, ErrorMessage = "O campo Setor Automotivo não pode ter mais de 1 caracteres.")]
        public string COD_SETOR_AUTOMOT { get; set; }

        [Display(Name = "Código Situação")]
        [StringLength(1, ErrorMessage = "O campo Código Situação não pode ter mais de 1 caracteres.")]
        public string COD_SITUA_RVTP { get; set; }

        [Display(Name = "Complexidade Industrial")]
        [StringLength(1, ErrorMessage = "O campo Complexidade Industrial não pode ter mais de 1 caracteres.")]
        public string COMPLEX_INDUST_RVTP { get; set; }

        [Display(Name = "Descrição Análise Risco")]
        [StringLength(512, ErrorMessage = "O campo Descrição Análise Risco não pode ter mais de 512 caracteres.")]
        public string DESC_ANALIS_RISCORVTP { get; set; }

        [Display(Name = "Descrição da Aplicação")]
        [RegularExpression("^([IA,C])+$", ErrorMessage = "O campo Descrição da Aplicação deve conter um dos seguintes valores: (I,A,C)")]        [StringLength(24, ErrorMessage = "O campo Descrição da Aplicação não pode ter mais de 24 caracteres.")]
        public string DESC_APLIC_CVTP { get; set; }

        [Display(Name = "Descrição Complexa")]
        [RegularExpression("^([BM,A])+$", ErrorMessage = "O campo Descrição Complexa deve conter um dos seguintes valores: (B,M,A)")]        [StringLength(12, ErrorMessage = "O campo Descrição Complexa não pode ter mais de 12 caracteres.")]
        public string DESC_COMPLEX_CVTP { get; set; }

        [Display(Name = "Descrição Condição Fornecedor")]
        [StringLength(512, ErrorMessage = "O campo Descrição Condição Fornecedor não pode ter mais de 512 caracteres.")]
        public string DESC_CONDIC_FORNRVTP { get; set; }

        [Display(Name = "Descrição do Grupo")]
        [StringLength(3, ErrorMessage = "O campo Descrição do Grupo não pode ter mais de 3 caracteres.")]
        public string DESC_GRUPO_CVTP { get; set; }

        [Display(Name = "Descrição Impacto Relevante")]
        [StringLength(512, ErrorMessage = "O campo Descrição Impacto Relevante não pode ter mais de 512 caracteres.")]
        public string DESC_IMPACT_RELEVRVTP { get; set; }

        [Display(Name = "Descrição Informação Fornecida")]
        [StringLength(1024, ErrorMessage = "O campo Descrição Informação Fornecida não pode ter mais de 1024 caracteres.")]
        public string DESC_INFORMAC_FORN { get; set; }

        [Display(Name = "Motivo da Consulta")]
        [StringLength(24, ErrorMessage = "O campo Motivo da Consulta não pode ter mais de 24 caracteres.")]
        public string DESC_MOTIV_CONSULTA { get; set; }

        [Display(Name = "Descrição da Norma do Cliente")]
        [StringLength(1040, ErrorMessage = "O campo Descrição da Norma do Cliente não pode ter mais de 1040 caracteres.")]
        public string DESC_NORMA_CLIENTE { get; set; }

        [Display(Name = "Quantidade Fornecida")]
        public decimal? DESC_QTD_FORNEC { get; set; }

        [Display(Name = "Descrição de Recusa")]
        [StringLength(1024, ErrorMessage = "O campo Descrição de Recusa não pode ter mais de 1024 caracteres.")]
        public string DESC_RECUSA_CVTP { get; set; }

        [Display(Name = "Data de Análise RVTP")]
        public DateTime? DTH_ANALIS_RVTP { get; set; }

        [Display(Name = "Data de Cadastro")]
        public DateTime? DTH_CADAST_CVTP { get; set; }

        [Display(Name = "Data de Cadastro RVTP")]
        public DateTime? DTH_CADAST_RVTP { get; set; }

        [Display(Name = "Data Hora Envio")]
        public DateTime? DTH_ENVIO_RVTP { get; set; }

        [Display(Name = "Data de Recebimento")]
        public DateTime? DTH_RECEB_CVTP { get; set; }

        [Display(Name = "Data de Recusa")]
        public DateTime? DTH_RECUSA_CVTP { get; set; }

        [Display(Name = "Fluxo Rotina Produto")]
        [StringLength(256, ErrorMessage = "O campo Fluxo Rotina Produto não pode ter mais de 256 caracteres.")]
        public string FLUXO_ROTIN_PRODRVTP { get; set; }

        [Display(Name = "Identificador Custo Privado")]
        [StringLength(1, ErrorMessage = "O campo Identificador Custo Privado não pode ter mais de 1 caracteres.")]
        public string IDC_CUSTO_PRVTP { get; set; }

        [Display(Name = "Envio Rotativo")]
        [StringLength(1, ErrorMessage = "O campo Envio Rotativo não pode ter mais de 1 caracteres.")]
        public string IDC_ENVIO_RVTP { get; set; }

        [Display(Name = "Flag Rotativo")]
        [StringLength(1, ErrorMessage = "O campo Flag Rotativo não pode ter mais de 1 caracteres.")]
        public string IDC_FLAG_RVTP { get; set; }

        [Display(Name = "Fluxo Rotativo Código")]
        [StringLength(1, ErrorMessage = "O campo Fluxo Rotativo Código não pode ter mais de 1 caracteres.")]
        public string IDC_FLUXO_ROTRVTP { get; set; }

        [Display(Name = "Tipo Fornecedor Privado")]
        [StringLength(1, ErrorMessage = "O campo Tipo Fornecedor Privado não pode ter mais de 1 caracteres.")]
        public string IDC_TIPO_FORNRVTP { get; set; }

        [Display(Name = "Impacto Relevante Processo")]
        [StringLength(1, ErrorMessage = "O campo Impacto Relevante Processo não pode ter mais de 1 caracteres.")]
        public string IMPACT_RELEV_PROCERVTP { get; set; }

        [Display(Name = "Limite ESC2 Máximo")]
        public decimal? LIMIT_ESCDOIS_MAX { get; set; }

        [Display(Name = "Limite ESC2 Mínimo")]
        public decimal? LIMIT_ESCDOIS_MIN { get; set; }

        [Display(Name = "Unidade de Limite ESC2")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Limite ESC2 não pode ter mais de 10 caracteres.")]
        public string LIMIT_ESCDOIS_UNID { get; set; }

        [Display(Name = "Limite Escuma Máximo")]
        public decimal? LIMIT_ESCUM_MAX { get; set; }

        [Display(Name = "Limite Escuma Mínimo")]
        public decimal? LIMIT_ESCUM_MIN { get; set; }

        [Display(Name = "Unidade de Limite de Escuma")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Limite de Escuma não pode ter mais de 10 caracteres.")]
        public string LIMIT_ESCUM_UNID { get; set; }

        [Display(Name = "Limite Residual Máximo")]
        public decimal? LIMIT_RES_MAX { get; set; }

        [Display(Name = "Limite Residual Mínimo")]
        public decimal? LIMIT_RES_MIN { get; set; }

        [Display(Name = "Unidade de Limite Residual")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Limite Residual não pode ter mais de 10 caracteres.")]
        public string LIMIT_RES_UNID { get; set; }

        [Display(Name = "Norma de Referência")]
        [StringLength(1040, ErrorMessage = "O campo Norma de Referência não pode ter mais de 1040 caracteres.")]
        public string NORMA_REFER_CVTP { get; set; }

        [Display(Name = "Peso Líquido do Produto")]
        public decimal? PES_LIQUI_PROD { get; set; }

        [Display(Name = "Produto SAP Simulador")]
        [StringLength(124, ErrorMessage = "O campo Produto SAP Simulador não pode ter mais de 124 caracteres.")]
        public string PRODUT_SAP_SIMRVTP { get; set; }

        [Display(Name = "Quantidade de Conjunto de Dimensões")]
        public decimal? QTD_CONJ_DIMENS { get; set; }

        [Display(Name = "Tamanho de Grão Máximo")]
        public decimal? TAM_GRAO_MAX { get; set; }

        [Display(Name = "Tamanho de Grão Mínimo")]
        public decimal? TAM_GRAO_MIN { get; set; }

        [Display(Name = "Unidade de Tamanho de Grão")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Tamanho de Grão não pode ter mais de 10 caracteres.")]
        public string TAM_GRAO_UNID { get; set; }

        [Display(Name = "Valor WKG")]
        public int? VALOR_WKG { get; set; }

        [Display(Name = "Valor do Diâmetro Especial")]
        public decimal? VLR_DIAM_ESPEC { get; set; }

        [Display(Name = "Valor de Dureza Máxima")]
        public decimal? VLR_DUREZA_MAX { get; set; }

        [Display(Name = "Valor de Dureza Mínima")]
        public decimal? VLR_DUREZA_MIN { get; set; }

        [Display(Name = "Valor de Impacto Máximo")]
        public decimal? VLR_IMPACTO_MAX { get; set; }

        [Display(Name = "Valor de Impacto Mínimo")]
        public decimal? VLR_IMPACTO_MIN { get; set; }

        [Display(Name = "Unidade de Valor de Impacto")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Valor de Impacto não pode ter mais de 10 caracteres.")]
        public string VLR_IMPACTO_UNID { get; set; }

        [Display(Name = "Valor Indução")]
        [StringLength(10, ErrorMessage = "O campo Valor Indução não pode ter mais de 10 caracteres.")]
        public string VLR_INDUC { get; set; }

        [Display(Name = "Valor Outro Máximo")]
        public decimal? VLR_OUTRO_MAX { get; set; }

        [Display(Name = "Valor Outro Mínimo")]
        public decimal? VLR_OUTRO_MIN { get; set; }

        [Display(Name = "Unidade de Valor Outro")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Valor Outro não pode ter mais de 10 caracteres.")]
        public string VLR_OUTRO_UNID { get; set; }

        [Display(Name = "Valor Outros")]
        [StringLength(124, ErrorMessage = "O campo Valor Outros não pode ter mais de 124 caracteres.")]
        public string VLR_OUTROS { get; set; }

        [Display(Name = "Valor Oxálico Máximo")]
        public decimal? VLR_OXALICO_MAX { get; set; }

        [Display(Name = "Valor Oxálico Mínimo")]
        public decimal? VLR_OXALICO_MIN { get; set; }

        [Display(Name = "Unidade de Valor Oxálico")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Valor Oxálico não pode ter mais de 10 caracteres.")]
        public string VLR_OXALICO_UNID { get; set; }

        [Display(Name = "Unidade de Dureza")]
        [StringLength(1, ErrorMessage = "O campo Unidade de Dureza não pode ter mais de 1 caracteres.")]
        public string VLR_UNID_DUREZA { get; set; }

        [Display(Name = "Valor Alongamento Máximo")]
        public decimal? VRL_ALONG_MAX { get; set; }

        [Display(Name = "Valor Alongamento Mínimo")]
        public decimal? VRL_ALONG_MIN { get; set; }

        [Display(Name = "Unidade de Valor de Alongamento")]
        [StringLength(10, ErrorMessage = "O campo Unidade de Valor de Alongamento não pode ter mais de 10 caracteres.")]
        public string VRL_ALONG_UNID { get; set; }

        [Display(Name = "Frequência")]
        [StringLength(10, ErrorMessage = "O campo Frequência não pode ter mais de 10 caracteres.")]
        public string VRL_FREQUENCIA { get; set; }

        [Display(Name = "Espessura Tolerância Centrada")]
        [RegularExpression("^([01])+$", ErrorMessage = "O campo Espessura Tolerância Centrada deve conter um dos seguintes valores: (0,1)")]        [StringLength(1, ErrorMessage = "O campo Espessura Tolerância Centrada não pode ter mais de 1 caracteres.")]
        public string ESP_TOLER_CENTRADA { get; set; }

        [Display(Name = "Espessura Tolerância Negativa")]
        [RegularExpression("^([01])+$", ErrorMessage = "O campo Espessura Tolerância Negativa deve conter um dos seguintes valores: (0,1)")]        [StringLength(1, ErrorMessage = "O campo Espessura Tolerância Negativa não pode ter mais de 1 caracteres.")]
        public string ESP_TOLER_NEGATIVA { get; set; }

        [Display(Name = "Espessura Tolerância Positiva")]
        [RegularExpression("^([01])+$", ErrorMessage = "O campo Espessura Tolerância Positiva deve conter um dos seguintes valores: (0,1)")]        [StringLength(1, ErrorMessage = "O campo Espessura Tolerância Positiva não pode ter mais de 1 caracteres.")]
        public string ESP_TOLER_POSITIVA { get; set; }

        [Display(Name = "Tipo Peso Bobina")]
        [StringLength(1, ErrorMessage = "O campo Tipo Peso Bobina não pode ter mais de 1 caracteres.")]
        public string TIPO_PESO_BOB { get; set; }

    }
}