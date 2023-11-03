using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpProprMecanicaViewModel
    {
        [Display(Name = "Número da Proposta Mecânica")]
        public decimal NUN_PROP_MECAN { get; set; }

        [Display(Name = "Número Sequencial CVTP")]
        public decimal? NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Código do Conjunto da Proposta")]
        public decimal? COD_CONJ_PROP { get; set; }

        [Display(Name = "Especificação Nominal do Produto")]
        public decimal? ESP_NOM_PRODT { get; set; }

        [Display(Name = "Tolerância Mínima da Especificação")]
        public decimal? TOL_MIN_ESP { get; set; }

        [Display(Name = "Tolerância Máxima da Especificação")]
        public decimal? TOL_MAX_ESP { get; set; }

        [Display(Name = "Largura Nominal do Produto")]
        public decimal? LAR_NOM_PRODT { get; set; }

        [Display(Name = "Tolerância Mínima da Largura")]
        public decimal? TOL_MIN_LAR { get; set; }

        [Display(Name = "Tolerância Máxima da Largura")]
        public decimal? TOL_MAX_LAR { get; set; }

        [Display(Name = "Comprimento Nominal do Produto")]
        public decimal? COMP_NOM_PRODT { get; set; }

        [Display(Name = "Tolerância Mínima do Comprimento")]
        public decimal? TOL_MIN_COMP { get; set; }

        [Display(Name = "Tolerância Máxima do Comprimento")]
        public decimal? TOL_MAX_COMP { get; set; }

        [Display(Name = "Código do Tipo de Borda")]
        [RegularExpression("^([BA BN])+$", ErrorMessage = "O campo Código do Tipo de Borda deve conter um dos seguintes valores: (BA, BN)")]        [StringLength(2, ErrorMessage = "O campo Código do Tipo de Borda não pode ter mais de 2 caracteres.")]
        public string COD_TIPO_BORDA { get; set; }

        [Display(Name = "Data e Hora de Cadastro do Registro")]
        public DateTime? DTH_CAD_REG { get; set; }

        [Display(Name = "Código de Registro de Usuário")]
        public decimal? COD_REG_USUAR { get; set; }

        [Display(Name = "Código de Registro de Empregado")]
        public decimal? COD_REG_EMPRG { get; set; }

    }
}