using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpSolicCustoViewModel
    {
        [Display(Name = "Código da Solicitacao de analise de custo")]
        public decimal COD_SOLIC_CUSTO { get; set; }

        [Display(Name = "Número Sequencial CVTP")]
        public decimal? NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Código do Cliente")]
        public decimal? COD_CLIENTE { get; set; }

        [Display(Name = "Descrição do Aço RVTP")]
        [StringLength(24, ErrorMessage = "O campo Descrição do Aço RVTP não pode ter mais de 24 caracteres.")]
        public string DESC_ACO_RVTP { get; set; }

        [Display(Name = "Descrição do Grupo CVTP")]
        [StringLength(24, ErrorMessage = "O campo Descrição do Grupo CVTP não pode ter mais de 24 caracteres.")]
        public string DESC_GRUPO_CVTP { get; set; }

        [Display(Name = "Código do Acabamento/Revestimento")]
        [StringLength(2, ErrorMessage = "O campo Código do Acabamento/Revestimento não pode ter mais de 2 caracteres.")]
        public string COD_ACAB_REVEST { get; set; }

        [Display(Name = "Detalhamento das Dimensões para Análise")]
        [StringLength(256, ErrorMessage = "O campo Detalhamento das Dimensões para Análise não pode ter mais de 256 caracteres.")]
        public string DETAL_DIMENS_ANALIS { get; set; }

        [Display(Name = "Custo Direto ABC")]
        public decimal? CUSTO_DIRETO_ABC { get; set; }

        [Display(Name = "Data e Hora de Cadastro do Registro")]
        public DateTime? DTH_CAD_REG { get; set; }

        [Display(Name = "Código de Registro de Usuário")]
        public decimal? COD_REG_USUAR { get; set; }

        [Display(Name = "Código de Registro de Empregado")]
        public decimal? COD_REG_EMPRG { get; set; }

    }
}