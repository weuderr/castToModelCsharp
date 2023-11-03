using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpControladoriaViewModel
    {
        [Display(Name = "Código de Análise de Controle")]
        public decimal COD_ANALIS_CONTROL { get; set; }

        [Display(Name = "Número Sequencial CVTP")]
        public decimal? NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Código de Revisão CVTP")]
        public decimal? COD_REVIS_CVTP { get; set; }

        [Display(Name = "Código de Registro de Usuário")]
        public decimal? COD_REG_USUAR { get; set; }

        [Display(Name = "Código de Registro de Empregado")]
        public decimal? COD_REG_EMPRG { get; set; }

        [Display(Name = "Código da Sigla da Lotação")]
        [StringLength(5, ErrorMessage = "O campo Código da Sigla da Lotação não pode ter mais de 5 caracteres.")]
        public string COD_SIGLA_LOTAC { get; set; }

        [Display(Name = "E-mail de Análise de Custo")]
        [StringLength(48, ErrorMessage = "O campo E-mail de Análise de Custo não pode ter mais de 48 caracteres.")]
        public string E-MAIL_ANALIS_CUSTO { get; set; }

        [Display(Name = "Produto SAP Similar")]
        [StringLength(48, ErrorMessage = "O campo Produto SAP Similar não pode ter mais de 48 caracteres.")]
        public string PRODUT_SAP_SIMILAR { get; set; }

        [Display(Name = "Ano e Mês de Referência")]
        public DateTime? ANO_MES_REFER { get; set; }

        [Display(Name = "Quantidade de Aço para Análise de Custo")]
        public decimal? QTDE_AÇO_ANALCUSTO { get; set; }

        [Display(Name = "Status da Análise de Custo")]
        [StringLength(4, ErrorMessage = "O campo Status da Análise de Custo não pode ter mais de 4 caracteres.")]
        public string STATUS_ANALIS_CUSTO { get; set; }

        [Display(Name = "Data e Hora de Início da Análise de Custo")]
        public DateTime? DTH_INIC_ANALCUSTO { get; set; }

        [Display(Name = "Data e Hora de Envio da Análise de Custo")]
        public DateTime? DTH_ENVIO_ANALCUSTO { get; set; }

    }
}