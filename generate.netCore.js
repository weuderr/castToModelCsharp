const fs = require("fs");
const path = require("path");
const {join} = require("path");
const {lowerFirstLetter} = require("./lib/Utils");

const fileGenerator = process.argv.slice(2);
const baseNamespace = fileGenerator[0];
const nameFile = process.argv.slice(3);
const replaceName = process.argv.slice(4);

// Criação de diretórios
function createDotNetDirectories() {
  const directories = [
    'Generated/',
    'Generated/'+baseNamespace+'/',
    'Generated/'+baseNamespace+'/Models/',
    'Generated/'+baseNamespace+'/Interfaces/',
    'Generated/'+baseNamespace+'/Interfaces/Repositories/',
    'Generated/'+baseNamespace+'/Interfaces/Services/',
    'Generated/'+baseNamespace+'/Repositories/',
    'Generated/'+baseNamespace+'/Services/',
    'Generated/'+baseNamespace+'/Controllers/',
    'Generated/'+baseNamespace+'/Validations/',
  ];

  directories.forEach(dir => {
    if (fs.existsSync(path.join(__dirname, dir))) {
      return true;
    }
    fs.mkdirSync(path.join(__dirname, dir));
  });
}

function generateRepositoryInterface(className) {
  const content = `using ${baseNamespace}.Domain.Entities;
using ${baseNamespace}.Domain.Models.DTO;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
namespace ${baseNamespace}.Domain.Interfaces.Services
{
    public interface I${className}Repository : IBaseService<${className}>
    {
        // Métodos do repositório
        Task<IEnumerable<${className}>> GetAllAsync();
    }
}`;
  fs.writeFileSync(`Generated/${baseNamespace}/Interfaces/Repositories/I${className}Repository.cs`, content);
}

// Geração de arquivos
function generateModelFile(className, data) {
    const foreignKeys = [];
    const constructionDeclaration = [];


    const values = JSON.parse(data).map(field => {
          return `\t\t\tpublic ${field.Tipo} ${field.Atributo} { get; set; }`;
        }).join('\n')

    JSON.parse(data).forEach(field => {
      if (field.Obrigatoriedade.includes('FK')) {
        const nameTable = field.Obrigatoriedade.replace('FK:', '');
        // remove all id type upper case, lower case and with first letter upper case
        const nameReference = field.Atributo.charAt(0).toUpperCase() + field.Atributo.slice(1).replace(/_([A-Z])*/gi, "").toLowerCase();

        constructionDeclaration.push(`\t\t\tthis.${nameReference} = new HashSet<${nameTable}>();`);
        foreignKeys.push(`\t\t\tpublic virtual ICollection<${nameTable}> ${nameReference} { get; set; }`);
      }
    });

    const content = `using Microsoft.AspNetCore.Identity;
using SBeleza.Domain.Interfaces.Entities;
using SBeleza.Domain.Models;

    namespace ${baseNamespace}.Domain.Entities
    {
      public class ${className}: Entity
      {
        public ${className}()
        {
          /*
${constructionDeclaration.join('\n')}
          */
        }
        
${values}
        public Enumerators.DBStatus DBStatus { get; set; }

        /*
${foreignKeys.join('\n')}
        */
      }
    }`;
    fs.writeFileSync(`Generated/${baseNamespace}/Models/${className}.cs`, content);
}

function generateValidationFile(className, data) {
    const fields = JSON.parse(data);
    const validationRules = fields.map(field => {
      const baseRule = `\t\t\tRuleFor(prop => prop.${field.Atributo}).Cascade(CascadeMode.Stop)`;
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
using ${baseNamespace}.Domain.Entities;

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
    fs.writeFileSync(`Generated/${baseNamespace}/Validations/${className}Validation.cs`, content);
}

function generateRepository(className) {
  const content = `using ${baseNamespace}.Domain.Entities;
using ${baseNamespace}.Domain.Interfaces.Services;
using ${baseNamespace}.Infrastructure.Data.Context;
using Microsoft.EntityFrameworkCore;
using System.Linq.Dynamic.Core;
using ${baseNamespace}.Domain.Models;
using static ${baseNamespace}.Domain.Models.Enumerators;

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
  fs.writeFileSync(`Generated/${baseNamespace}/Repositories/${className}Repository.cs`, content);
}

function generateServiceInterface(className) {
  const content = `using SBeleza.Domain.Entities;
using SBeleza.Domain.Interfaces.Services;

namespace ${baseNamespace}.Domain.Interfaces.Repositories
{
    public interface I${className}Service : IBaseService<${className}>
    {
        Task<IEnumerable<${className}>> GetAllAsync();
    }
}`;
  fs.writeFileSync(`Generated/${baseNamespace}/Interfaces/Services/I${className}Service.cs`, content);
}

function generateService(className) {
  const content = `using SBeleza.Domain.Entities;
using SBeleza.Domain.Interfaces.Services;
using SBeleza.Domain.Models;
using SBeleza.Service.Validations;
using I${className}Repository = SBeleza.Domain.Interfaces.Repositories.I${className}Repository;

namespace ${baseNamespace}.Service.Services
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
  fs.writeFileSync(`Generated/${baseNamespace}/Services/${className}Service.cs`, content);
}

function generateController(className) {
  const controllerName = `${className}Controller`;
  const modelName = className;
  const varname = lowerFirstLetter(className);
  const serviceInterface = `I${className}Service`;
  const repositoryInterface = `I${className}Repository`;

  const content = `using AutoMapper;
using ${baseNamespace}.Domain.Entities;
using ${baseNamespace}.Domain.Entities.Identity;
using ${baseNamespace}.Domain.Interfaces.Services;
using ${baseNamespace}.Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using ${baseNamespace}.Presentation.Api.Controllers.Base;
using ${baseNamespace}.Presentation.App.Extensions;
using static ${baseNamespace}.Domain.Models.Enumerators;

namespace ${baseNamespace}.Presentation.Api.Controllers
{
    /// <summary>
    /// Inicializa uma nova instância da classe ${controllerName}.
    /// </summary>
    [Route("api/${modelName}")]
    [ApiController]
    public class ${controllerName} : BaseControlController
    {
        private readonly ${serviceInterface} _${varname}Service;
        
        /// <summary>
        /// Construtor para ${controllerName}.
        /// </summary>
        public ${controllerName}(IMapper mapper, UserManager<ApplicationUser> userManager, IErrorService errorService, I${modelName}Service ${varname}Service) : base(mapper, userManager, errorService)
        {
            _${varname}Service = ${varname}Service;
        }
        
        #region Métodos públicos ${modelName}
        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
              var ${modelName.toLowerCase()}List = await _${varname}Service.GetAllAsync();
              return Ok(JsonConvert.SerializeObject(${modelName.toLowerCase()}List));
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao buscar os registros!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(string id)
        {
            try
            {
              var ${modelName.toLowerCase()} = await _${varname}Service.GetById(id);
              if (${modelName.toLowerCase()} == null)
              {
                  return BadRequest( new { Message = "Registro não encontrado!" });
              }
              return Ok(JsonConvert.SerializeObject(${modelName.toLowerCase()}));
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
              
              await _${varname}Service.InsertAsync(${modelName.toLowerCase()});
              return Ok( new { Message = "Registro inserido com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao inserir o registro!" });
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

              var ${modelName.toLowerCase()}Old = await _${varname}Service.GetById(id);
              if (${modelName.toLowerCase()}Old == null)
              {
                  return NotFound();
              }

              await _${varname}Service.UpdateAsync(${modelName.toLowerCase()});
              return Ok( new { Message = "Registro atualizado com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao atualizar o registro!" });
            }
        }

        [Claims(new ClaimType[] { ClaimType.Webmaster, ClaimType.Administrator }, new ClaimValue[] { ClaimValue.R })]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
              var ${modelName.toLowerCase()} = await _${varname}Service.GetById(id);
              if (${modelName.toLowerCase()} == null)
              {
                  return NotFound();
              }

              await _${varname}Service.DeleteAsync(id);
              return Ok( new { Message = "Registro excluído com sucesso!" });
            }
            catch (System.Exception ex)
            {
                ErrorService.Add(new Error(ex.Message));
                return StatusCode(500, new { Message = "Erro ao excluir o registro!" });
            }
        }
        
        #endregion
    }
}`;
  fs.writeFileSync(`Generated/${baseNamespace}/Controllers/${controllerName}.cs`, content);
}



// Processamento e geração
async function processAndGenerate(files) {
  createDotNetDirectories();

  files.forEach(file => {
    if (file.includes('.json')) {
      let className = file.replace('.json', '');
      if(className === nameFile[0] || nameFile[0] === undefined) {

        fs.readFile(`${readFolder}${className}.json`, 'utf8', (err, data) => {
          if (err) {
            console.error(`Erro ao ler o arquivo para ${className}:`, err);
            return;
          }
          replaceName[0] ? className = replaceName[0] : null;

          generateRepositoryInterface(className);
          generateRepository(className);
          generateServiceInterface(className);
          generateService(className);
          generateController(className);
          generateModelFile(className, data);
          generateValidationFile(className, data);
        });
      }
    }
  });
}


const readFolder = join(__dirname, 'docs/', baseNamespace, '/');
async function init() {
  const files = fs.readdirSync(readFolder);

  await processAndGenerate(files);
}

init();
