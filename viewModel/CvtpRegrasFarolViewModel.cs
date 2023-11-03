using System;
using System.ComponentModel.DataAnnotations;

namespace Aperam.PCP.PNV.UI.ViewModels
{
    public class CvtpRegrasFarolViewModel
    {
        [Display(Name = "Código da Regra do Farol")]
        public decimal COD_REGRA_FAROL { get; set; }

        [Display(Name = "Código da Área de Negócio")]
        [StringLength(24, ErrorMessage = "O campo Código da Área de Negócio não pode ter mais de 24 caracteres.")]
        public string COD_AREA_NEGOCIO { get; set; }

        [Display(Name = "Limite de Hora de Retorno")]
        public decimal? LIMIT_HORA_RETORNO { get; set; }

        [Display(Name = "Percentual de Limite Amarelo")]
        public decimal? PERC_LIMIT_AMARELO { get; set; }

        [Display(Name = "Data de Cadastro da Regra")]
        public DateTime? DTH_CAD_REG { get; set; }

        [Display(Name = "Código do Registro do Usuário")]
        public decimal? COD_REG_USUAR { get; set; }

        [Display(Name = "Código do Registro da Empresa")]
        public decimal? COD_REG_EMPRG { get; set; }

    }
}