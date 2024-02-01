const fs = require("fs");
const path = require("path");
const {join} = require("path");

// Utilitários
const { ensureDirectoryExistence } = require("./src/lib/Utils"); // Adapte conforme necessário

const baseNamespace = "LollolBackoffice";

// Criação de diretórios
function createDotNetDirectories() {
  const directories = [
    'GeneratedDotNet/',
    'GeneratedDotNet/Models/',
    'GeneratedDotNet/Interfaces/',
    'GeneratedDotNet/Interfaces/Repositories/',
    'GeneratedDotNet/Interfaces/Services/',
    'GeneratedDotNet/Repositories/',
    'GeneratedDotNet/Services/',
    'GeneratedDotNet/Controllers/',
    'GeneratedDotNet/Validations/',
  ];

  directories.forEach(dir => ensureDirectoryExistence(path.join(__dirname, dir)));
}

function generateRepositoryInterface(className) {
  const content = `using LollolBackoffice.Domain.Entities;
using LollolBackoffice.Domain.Models.DTO;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
namespace LollolBackoffice.Domain.Interfaces.Services
{
    public interface I${className}Repository : IBaseService<${className}>
    {
        // Métodos do repositório
        Task<IEnumerable<${className}>> GetAllAsync();
    }
}`;
  fs.writeFileSync(`GeneratedDotNet/Interfaces/Repositories/I${className}Repository.cs`, content);
}

// Geração de arquivos
function generateModelFile(className) {
  fs.readFile(`${readFolder}${className}.json`, 'utf8', (err, data) => {
    const values = JSON.parse(data).map(field => {
          return `\t\tpublic ${field.Tipo} ${field.Atributo} { get; set; }`;
        }).join('\n')
    const content = `namespace ${baseNamespace}.Models
    {
      public class ${className}
      {
        public int Id { get; set; }
${values}
        }
      }
    }`;
    fs.writeFileSync(`GeneratedDotNet/Models/${className}.cs`, content);
  });
}

function generateValidationFile(className) {
  fs.readFile(`${readFolder}${className}.json`, 'utf8', (err, data) => {
    if (err) {
      console.error(`Erro ao ler o arquivo para ${className}:`, err);
      return;
    }

    const fields = JSON.parse(data);
    const validationRules = fields.map(field => {
      const baseRule = `RuleFor(prop => prop.${field.Atributo}).Cascade(CascadeMode.Stop)`;
      let rules = [];

      // Exemplo de regra: NotNull e NotEmpty para todos os campos
      rules.push(`${baseRule}\n\t\t\t.NotNull().WithMessage("é obrigatório informar o(a) ${field.Atributo.toLowerCase()}")\n\t\t\t.NotEmpty().WithMessage("é obrigatório informar o(a) ${field.Atributo.toLowerCase()}")`);

      // Adicione mais regras com base no tipo do campo, por exemplo, MaxLength para string
      if (field.Tipo === "string") {
        rules.push(`${baseRule}\n\t\t\t.MaximumLength(128).WithMessage("o(a) ${field.Atributo.toLowerCase()} deve ter no máximo 128 caracteres")`);
      }

      return rules.join(';\n');
    }).join(';\n\n');

    const content = `using FluentValidation;
using LollolBackoffice.Domain.Entities;

namespace ${baseNamespace}.Service.Validations
{
    public class ${className}Validation : AbstractValidator<${className}>
    {
        public ${className}Validation()
        {
${validationRules};
        }
    }
}`;
    fs.writeFileSync(`GeneratedDotNet/Validations/${className}Validation.cs`, content);
  });
}

function generateRepository(className) {
  const content = `using LollolBackoffice.Domain.Entities;
using LollolBackoffice.Domain.Interfaces.Services;
using LollolBackoffice.Infrastructure.Data.Context;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Threading.Tasks;
using LollolBackoffice.Domain.Models;
using static LollolBackoffice.Domain.Models.Enumerators;

namespace ${baseNamespace}.Infrastructure.Data.Repositories
{
    public class ${className}Repository : BaseRepository<${className}>, I${className}Repository
    {
        public ${className}Repository(ApplicationDbContext dbContext, IErrorService errorService) : base(dbContext, errorService)
        {
            // Construtor
        }

        public async Task<${className}> Get(string id)
        {
            return await DbSet
                   .AsNoTracking()
                   .FirstOrDefaultAsync(x => x.Id == id);
        }
        
        public async Task<IEnumerable<${className}>> GetAllAsync()
        {
            return await DbSet
                   .AsNoTracking()
                   .Where(x => x.DBStatus != DBStatus.Excluded)
                   .ToListAsync();
        }
        
        public async Task<IEnumerable<${className}>> GetAllAsync(string sort, int? page, int? pageSize)
        {
            IQueryable<${className}> query = DbSet
                                            .AsNoTracking()
                                            .Where(x => x.DBStatus != DBStatus.Excluded);
        
            if (!string.IsNullOrEmpty(sort))
            {
                query = query.OrderBy(sort);
            }
        
            if (page.HasValue && pageSize.HasValue)
            {
                query = query.Skip((page.Value - 1) * pageSize.Value).Take(pageSize.Value);
            }
        
            return await query.ToListAsync();
        }
        
        public async Task DeleteAsync(string id)
        {
            ${className} entity = await DbSet.FirstOrDefaultAsync(x => x.Id == id);
            if (entity == null)
            {
                ErrorService.Add(new Error("not found"));
                return;
            }
        
            entity.DBStatus = DBStatus.Excluded;
        
            await UpdateAsync(entity);
        }
    }
}`;
  fs.writeFileSync(`GeneratedDotNet/Repositories/${className}Repository.cs`, content);
}

function generateServiceInterface(className) {
  const content = `using System.Collections.Generic;
using System.Threading.Tasks;
using LollolBackoffice.Domain.Entities;

namespace LollolBackoffice.Domain.Interfaces.Services
{
    public interface I${className}Service : IBaseService<${className}>
    {
        Task<IEnumerable<${className}>> GetAllAsync();
    }
}`;
  fs.writeFileSync(`GeneratedDotNet/Interfaces/Services/I${className}Service.cs`, content);
}

function generateService(className) {
  const content = `using LollolBackoffice.Domain.Entities;
using LollolBackoffice.Domain.Interfaces.Repositories;
using LollolBackoffice.Domain.Interfaces.Services;
using LollolBackoffice.Domain.Models;
using LollolBackoffice.Service.Validations;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static LollolBackoffice.Domain.Models.Enumerators;

namespace LollolBackoffice.Service
{
    public class ${className}Service : BaseService, I${className}Service
    {
        private readonly IErrorService _errorService;
        private readonly I${className}Repository _repository;

        public ${className}Service(IErrorService errorService, I${className}Repository repository) : base(errorService)
        {
            _errorService = errorService;
            _repository = repository;
        }

        public async Task InsertAsync(${className} entity)
        {
            if (!RunValidation(new ${className}Validation(), entity)) return;

            entity.Id = Guid.NewGuid().ToString();
            entity.Created = DateTime.Now;
            entity.LastUpdated = entity.Created;

            await _repository.InsertAsync(entity);
        }

        public async Task UpdateAsync(${className} entity)
        {
            if (!RunValidation(new ${className}Validation(), entity)) return;

            entity.LastUpdated = DateTime.Now;

            await _repository.UpdateAsync(entity);
        }

        public async Task DeleteAsync(string id)
        {
            ${className} entity = await _repository.GetById(id);
            if (entity == null)
            {
                _errorService.Add(new Error("not found"));
                return;
            }

            entity.DBStatus = DBStatus.Excluded;

            await _repository.DeleteAsync(entity.Id);
        }

        public async Task<${className}> GetById(string id)
        {
            ${className} entity = await _repository.GetById(id);
            if (entity == null)
            {
                _errorService.Add(new Error("not found"));
            }

            return entity;
        }

        public async Task<IEnumerable<${className}>> GetAllAsync()
        {
            return await _repository.GetAllAsync();
        }

        public void Dispose()
        {
            _repository.Dispose();
        }
    }
}`;
  fs.writeFileSync(`GeneratedDotNet/Services/${className}Service.cs`, content);
}

function generateController(className) {
  const controllerName = `${className}Controller`;
  const modelName = className;
  const serviceInterface = `I${className}Service`;
  const repositoryInterface = `I${className}Repository`;

  const content = `using AutoMapper;
using LollolBackoffice.Domain.Entities;
using LollolBackoffice.Domain.Entities.Identity;
using LollolBackoffice.Domain.Interfaces.Services;
using LollolBackoffice.Domain.Models;
using LollolBackoffice.Presentation.App.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using static LollolBackoffice.Domain.Models.Enumerators;

namespace ${baseNamespace}.Presentation.App.Controllers
{
    [Route("${modelName}")]
    [ApiController]
    public class ${controllerName} : BaseController
    {
        private readonly ${serviceInterface} _${modelName}Service;

        public ${controllerName}(IMapper mapper, UserManager<ApplicationUser> userManager, IErrorService errorService, I${modelName}Service ${modelName}Service) : base(mapper, userManager, errorService)
        {
            _${modelName}Service = ${modelName}Service;
        }
        
        #region Métodos públicos ${modelName}
        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
              var ${modelName.toLowerCase()}List = _${modelName}Service.GetAllAsync();
              return Ok(${modelName.toLowerCase()}List);
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao buscar!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(string id)
        {
            try
            {
              var ${modelName.toLowerCase()} = _${modelName}Service.GetById(id);
              if (${modelName.toLowerCase()} == null)
              {
                  return BadRequest( new { Message = "Registro não encontrado!" });
              }
              return Ok(${modelName.toLowerCase()});
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao buscar o registro!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ${modelName} ${modelName.toLowerCase()})
        {
            try
            {
              if (${modelName.toLowerCase()} == null)
              {
                  return BadRequest( new { Message = "Registro não encontrado!" });
              }
              
              await _${modelName}Service.InsertAsync(${modelName.toLowerCase()});
              return Ok( new { Message = "Registro inserido com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao inserir!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(string id, [FromBody] ${modelName} ${modelName.toLowerCase()})
        {
            try
            {
              if (${modelName.toLowerCase()} == null || ${modelName.toLowerCase()}.Id != id)
              {
                  return BadRequest();
              }

              var ${modelName.toLowerCase()}Old = _${modelName}Service.GetById(id);
              if (${modelName.toLowerCase()}Old == null)
              {
                  return NotFound();
              }

              _${modelName}Service.UpdateAsync(${modelName.toLowerCase()});
              return Ok( new { Message = "Registro atualizado com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao atualizar!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
              var ${modelName.toLowerCase()} = _${modelName}Service.GetById(id);
              if (${modelName.toLowerCase()} == null)
              {
                  return NotFound();
              }

              _${modelName}Service.DeleteAsync(id);
              return Ok( new { Message = "Registro excluído com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao excluir!" });
            }
        }
        
        #endregion
    }
}`;
  fs.writeFileSync(`GeneratedDotNet/Controllers/${controllerName}.cs`, content);
}



// Processamento e geração
async function processAndGenerate(files) {
  createDotNetDirectories();

  files.forEach(file => {
    const className = file.replace('.json', '');
    generateModelFile(className);
    generateRepositoryInterface(className);
    generateRepository(className);
    generateServiceInterface(className);
    generateService(className);
    generateController(className);
    generateValidationFile(className);
  });
}


const readFolder = join(__dirname, 'docs/dotnetCast/');
async function init() {
  const files = fs.readdirSync(readFolder);

  await processAndGenerate(files);
}

init();
