using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpAnalisQuimicaViewModel
    {
        [Display(Name = "Código do Elemento Químico")]
        public decimal COD_ELEM_QUIMICO { get; set; }

        [Display(Name = "Número Sequencial CVTP")]
        public decimal? NUN_SEQ_CVTP { get; set; }

        [Display(Name = "Código da Unidade do Elemento")]
        [Required(ErrorMessage = "O campo Código da Unidade do Elemento é obrigatório.")]
        [StringLength(10, ErrorMessage = "O campo Código da Unidade do Elemento não pode ter mais de 10 caracteres.")]
        public string COD_UNID_ELEM { get; set; }

        [Display(Name = "Número do Valor Mínimo")]
        public decimal? NUM_VLR_MIN { get; set; }

        [Display(Name = "Número do Valor Máximo")]
        public decimal? NUM_VLR_MAX { get; set; }

        [Display(Name = "Data e Hora de Cadastro do Registro")]
        [Required(ErrorMessage = "O campo Data e Hora de Cadastro do Registro é obrigatório.")]
        public DateTime DTH_CAD_REG { get; set; }

        [Display(Name = "Código de Registro de Usuário")]
        [Required(ErrorMessage = "O campo Código de Registro de Usuário é obrigatório.")]
        public decimal COD_REG_USUAR { get; set; }

        [Display(Name = "Código de Registro de Empregado")]
        [Required(ErrorMessage = "O campo Código de Registro de Empregado é obrigatório.")]
        public decimal COD_REG_EMPRG { get; set; }

    }
}