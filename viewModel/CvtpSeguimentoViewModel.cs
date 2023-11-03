using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpSeguimentoViewModel
    {
        [Display(Name = "Código de Segmento CVTP")]
        public decimal COD_SEG_CVTP { get; set; }

        [Display(Name = "Descrição do Segmento")]
        [Required(ErrorMessage = "O campo Descrição do Segmento é obrigatório.")]
        [StringLength(24, ErrorMessage = "O campo Descrição do Segmento não pode ter mais de 24 caracteres.")]
        public string DESC_SEGUIMENTO { get; set; }

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