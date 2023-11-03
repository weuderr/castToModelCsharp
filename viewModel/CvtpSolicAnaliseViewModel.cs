using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpSolicAnaliseViewModel
    {
        [Display(Name = "Código da Solicitação de Análise")]
        public decimal COD_SOLIC_ANALISE { get; set; }

        [Display(Name = "Número Sequencial CVTP")]
        public decimal? NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Procedimento de Solicitação de Análise")]
        [RegularExpression("^([ESP CO])+$", ErrorMessage = "O campo Procedimento de Solicitação de Análise deve conter um dos seguintes valores: (ESP, CO)")]        [StringLength(124, ErrorMessage = "O campo Procedimento de Solicitação de Análise não pode ter mais de 124 caracteres.")]
        public string PROC_SOLIC_ANALIS { get; set; }

        [Display(Name = "Data e Hora da Solicitação de Análise")]
        public DateTime? DHT_SOLIC_ANALISE { get; set; }

        [Display(Name = "Email de Envio de Análise")]
        [StringLength(1024, ErrorMessage = "O campo Email de Envio de Análise não pode ter mais de 1024 caracteres.")]
        public string EMAIL_ENVIO_ANALISE { get; set; }

        [Display(Name = "Código da Área de Solicitação")]
        [StringLength(5, ErrorMessage = "O campo Código da Área de Solicitação não pode ter mais de 5 caracteres.")]
        public string COD_AREA_SOLICIT { get; set; }

        [Display(Name = "Email Direcionado de Email")]
        [StringLength(1024, ErrorMessage = "O campo Email Direcionado de Email não pode ter mais de 1024 caracteres.")]
        public string EMAIL_DIREC_EMAIL { get; set; }

        [Display(Name = "Descrição Detalhada de Email")]
        [StringLength(512, ErrorMessage = "O campo Descrição Detalhada de Email não pode ter mais de 512 caracteres.")]
        public string DESC_DETAL_EMAIL { get; set; }

        [Display(Name = "Data e Hora Limite de Retorno")]
        public DateTime? DTH_LIMITE_RETORN { get; set; }

        [Display(Name = "Usuário da Solicitação de Análise")]
        public decimal? USUAR_SOLIC_ANALIS { get; set; }

        [Display(Name = "Empresa da Solicitação de Análise")]
        public decimal? EMPRG_SOLIC_ANALIS { get; set; }

        [Display(Name = "Descrição de Análise de Email")]
        [StringLength(512, ErrorMessage = "O campo Descrição de Análise de Email não pode ter mais de 512 caracteres.")]
        public string DESC_ANALIS_EMAIL { get; set; }

        [Display(Name = "Data e Hora de Retorno de Análise")]
        public DateTime? DHT_RETORN_ANALISE { get; set; }

        [Display(Name = "Indicador de Anexo de Análise")]
        [StringLength(1, ErrorMessage = "O campo Indicador de Anexo de Análise não pode ter mais de 1 caracteres.")]
        public string IDC_ANEXO_ANALISE { get; set; }

        [Display(Name = "Usuário de Retorno de Análise")]
        public decimal? USUAR_RETOR_ANALIS { get; set; }

        [Display(Name = "Empresa de Retorno de Análise")]
        public decimal? EMPRG_RETOR_ANALIS { get; set; }

    }
}