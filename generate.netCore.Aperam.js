const fs = require("fs");
const path = require("path");
const {join} = require("path");
const {lowerFirstLetter} = require("./lib/Utils");

const fileGenerator = process.argv.slice(2);
const baseNamespace = fileGenerator[0];
const nameFile = process.argv.slice(3);
const replaceName = process.argv.slice(4);

// cast to pascalCase like a NOME_DO_ATRIBUTO -> NomeDoAtributo
function castToPascalCase(attribute) {
  const words = attribute.split('_');
  const camelCaseWords = words.map((word, index) => {
    // if (index === 0) {
    //     return word.toLowerCase();
    // }
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });
  return camelCaseWords.join('');
}

function castCamelCase(attribute) {
  const words = attribute.split('_');
  const camelCaseWords = words.map((word, index) => {
    if (index === 0) {
        return word.toLowerCase();
    }
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });
  return camelCaseWords.join('');
}

// inverse of castToPascalCase
function castToSnakeCase(attribute) {
    const words = attribute.split(/(?=[A-Z])/);
    const snakeCaseWords = words.map(word => word.toLowerCase());
    return snakeCaseWords.join('_');
}

// Criação de diretórios
function createDotNetDirectories() {
  const directories = [
    'Generated/',
    'Generated/'+baseNamespace+'/',
    'Generated/'+baseNamespace+'/Models/',
    'Generated/'+baseNamespace+'/Interfaces/',
    'Generated/'+baseNamespace+'/ViewModels/',
    'Generated/'+baseNamespace+'/Entities/',
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
  const content = `using Aperam.${baseNamespace}.Domain.Entities;
using Aperam.${baseNamespace}.Domain.Models.DTO;
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
  const typeMapping = {
    "NUMBER": "int",
    "VARCHAR2": "string",
    "DATE": "DateTime",
    "CLOB": "string",
    "DECIMAL": "decimal",
    "TIMESTAMP": "DateTime",
    "CHAR": "string"
  };

  const converted = JSON.parse(data);
  const properties = converted.map(field => {
    const csharpType = typeMapping[field.Tipo.toUpperCase()] || "object";
    const camelCaseAttribute = castToPascalCase(field.Atributo);
    const isForeignKey = field.Observacoes && field.Observacoes.toUpperCase().includes("FOREIGN KEY");
    const foreignKey = isForeignKey ? `\n        public ICollection<${camelCaseAttribute}> ${camelCaseAttribute} { get; set; }` : "";

    return `        public ${csharpType} ${camelCaseAttribute} { get; set; }${foreignKey}`;
  }).join('\n\n');

  const content = `using Microsoft.AspNetCore.Identity;
using ${baseNamespace}.Domain.Interfaces.Entities;
using ${baseNamespace}.Domain.Models;

namespace ${baseNamespace}.Domain.Entities
{
    public class ${className} : Entity
    {
        public ${className}()
        {
        }

${properties}
    }
}`;

  fs.writeFileSync(`Generated/${baseNamespace}/Models/${className}.cs`, content);
}

const typeMapping = {
  "NUMBER": "int",
  "VARCHAR2": "string",
  "DATE": "DateTime",
  "CLOB": "string",
  "DECIMAL": "decimal",
  "TIMESTAMP": "DateTime",
  "CHAR": "string"
};

function generateViewModel(className, data) {
  const typeMapping = {
    "NUMBER": "int",
    "VARCHAR2": "string",
    "DATE": "DateTime",
    "CLOB": "string",
    "DECIMAL": "decimal",
    "TIMESTAMP": "DateTime",
    "CHAR": "string"
  };

  const fields = JSON.parse(data);
  const properties = fields.map(field => {
    const csharpType = typeMapping[field.Tipo.toUpperCase()] || "object";
    const camelCaseAttribute = castToPascalCase(field.Atributo);
    const isForeignKey = field.Observacoes && field.Observacoes.toUpperCase().includes("FOREIGN KEY");
    const foreignKey = isForeignKey ? `\n        public ICollection<${camelCaseAttribute}> ${camelCaseAttribute} { get; set; }` : "";

    return `public ${csharpType} ${camelCaseAttribute} { get; set; }${foreignKey}`;
  }).join('\n\n');

  const content = `using System;

namespace ${baseNamespace}.API.ViewModels
{
    public class ${className}ViewModel
    {
${properties}
    }
}`;

  fs.writeFileSync(`Generated/${baseNamespace}/ViewModels/${className}ViewModel.cs`, content);
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
using Aperam.${baseNamespace}.Domain.Entities;

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

function generateRepository(className, data) {
  const tableName = `ACESITA_LAL.${castToSnakeCase(className).toUpperCase()}`;
  const converted = JSON.parse(data);

  let primaryKeyField = converted.find(field => field.Obrigatoriedade && field.Obrigatoriedade.toLowerCase().includes("primary key"));
  !primaryKeyField ? primaryKeyField = converted[0] : null;
  const primaryKey = primaryKeyField ? castToPascalCase(primaryKeyField.Atributo) : "id";

  const selectFields = converted.map(field => {
    return `                        ${field.Atributo.toUpperCase()} AS ${castToPascalCase(field.Atributo)}`;
  }).join(",\n");

  const repositoryContent = `using Dapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Aperam.LAL.Infrastructure.Entity;
using Aperam.LAL.Infrastructure.Repositories;

namespace Aperam.${baseNamespace}.Infrastructure.Repositories
{
    public class ${className}Repository : BaseRepository<${className}Entity>
    {
        public async Task<IEnumerable<${className}Entity>> GetAllAsync()
        {
            try {
              using (var cn = base.AcessoDadosOracle())
              {
                  var sql = $@"SELECT 
${selectFields}
                  FROM ${tableName}";
                  return await cn.QueryAsync<${className}Entity>(sql);
              }
            } catch (System.Exception ex) {
                throw ex;
            }   
        }

        public async Task<${className}Entity> GetByIdAsync(${typeMapping[primaryKeyField.Tipo] || "int"} ${primaryKey})
        {
            try {
              using (var cn = base.AcessoDadosOracle())
              {
                  var sql = $@"SELECT 
${selectFields}
                  FROM ${tableName}
                  WHERE ${primaryKeyField ? primaryKeyField.Atributo.toUpperCase() : "ID"} = @${primaryKey}";
                  return await cn.QueryFirstOrDefaultAsync<${className}Entity>(sql, new { ${primaryKey} });
              }
            } catch (System.Exception ex) {
                throw ex;
            }
        }

        public async Task<int> InsertAsync(${className}Entity entity)
        {
            try {  
              using (var cn = base.AcessoDadosOracle())
              {
                  var sql = $@"INSERT INTO ${tableName} (
                  ${converted.map(field => field.Atributo.toUpperCase()).join(",\n")}
                  ) VALUES (
                  ${converted.map(field => `@${castToPascalCase(field.Atributo)}`).join(",\n")}
                  )";
                  return await cn.ExecuteAsync(sql, entity);
              }
            } catch (System.Exception ex) {
                throw ex;
            }
        }

        public async Task<int> UpdateAsync(${className}Entity entity)
        {
            try { 
              using (var cn = base.AcessoDadosOracle())
              {
                  var sql = $@"UPDATE ${tableName}
                  SET
                  ${converted.map(field => `${field.Atributo.toUpperCase()} = @${castToPascalCase(field.Atributo)}`).join(",\n")}
                  WHERE ${primaryKeyField ? primaryKeyField.Atributo.toUpperCase() : "ID"} = @${primaryKey}";
                  return await cn.ExecuteAsync(sql, entity);
              }
            } catch (System.Exception ex) {
                throw ex;
            }
        }

        public async Task<int> DeleteAsync(${typeMapping[primaryKeyField.Tipo] || "int"} ${primaryKey})
        {
            try {  
              using (var cn = base.AcessoDadosOracle())
              {
                  var sql = $@"DELETE FROM ${tableName}
                  WHERE ${primaryKeyField ? primaryKeyField.Atributo.toUpperCase() : "ID"} = @${primaryKey}";
                  return await cn.ExecuteAsync(sql, new { ${primaryKey} });
              }
            } catch (System.Exception ex) {
                throw ex;
            }
        }
    }
}`;

  fs.writeFileSync(`Generated/${baseNamespace}/Repositories/${className}Repository.cs`, repositoryContent);
}

function generateEntityFile(className, data) {
  const typeMapping = {
    "NUMBER": "int",
    "VARCHAR2": "string",
    "DATE": "DateTime",
    "CLOB": "string",
    "DECIMAL": "decimal",
    "TIMESTAMP": "DateTime",
    "CHAR": "string"
  };

  const converted = JSON.parse(data);
  const properties = converted.map(field => {
    const csharpType = typeMapping[field.Tipo.toUpperCase()] || "object";
    const camelCaseAttribute = castToPascalCase(field.Atributo);
    const columnName = field.Atributo.toUpperCase();
    const isPrimaryKey = field.Observacoes && field.Observacoes.toLowerCase().includes("primary key");
    const isForeignKey = field.Observacoes && field.Observacoes.toUpperCase().includes("FOREIGN KEY");
    const databaseGenerated = isPrimaryKey ? "[DatabaseGenerated(DatabaseGeneratedOption.None)]\n" : "";
    const foreignKey = isForeignKey ? `\n        public virtual ICollection<${camelCaseAttribute}> ${camelCaseAttribute} { get; set; }` : "";

    return `${(isPrimaryKey ? "[Key]\n" : "")}[Column(\"${columnName}\")]\n${databaseGenerated}public ${csharpType} ${camelCaseAttribute} { get; set; }${foreignKey}`;
  }).join('\n\n');

  const content = `using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ${baseNamespace}.Infrastructure.Entity
{
    [Table("ACESITA_PESA.${className.toUpperCase()}")]
    public class ${className}Entity
    {
${properties}
    }
}`;

  fs.writeFileSync(`Generated/${baseNamespace}/Entities/${className}Entity.cs`, content);
}

function generateServiceInterface(className) {
  const content = `using Aperam.${baseNamespace}.Domain.Entities;
using Aperam.${baseNamespace}.Domain.Interfaces.Services;

namespace ${baseNamespace}.Domain.Interfaces.Repositories
{
    public interface I${className}Service : IBaseService<${className}>
    {
        Task<IEnumerable<${className}>> GetAllAsync();
    }
}`;
  fs.writeFileSync(`Generated/${baseNamespace}/Interfaces/Services/I${className}Service.cs`, content);
}

function generateService(className, primaryKeyField) {
  const namePrimaryKey = primaryKeyField ? castCamelCase(primaryKeyField.Atributo) : "id";

  const content = `using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using Aperam.${baseNamespace}.Domain.Entities;
using Aperam.${baseNamespace}.Infrastructure.Entity;
using Aperam.${baseNamespace}.Infrastructure.Repositories;

namespace Aperam.${baseNamespace}.Domain.Service
{
    public class ${className}Service : BaseService<${className}>
    {
        private readonly ${className}Repository _localRepository${className} = new ${className}Repository();

        public ${className}Service()
        {
        }

        public async Task<IEnumerable<${className}>> GetAllAsync()
        {
            var entities = await _localRepository${className}.GetAllAsync();
            return Mapper.Map<IEnumerable<${className}>>(entities);
        }

        public async Task<${className}> GetByIdAsync(${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey})
        {
            var entity = await _localRepository${className}.GetByIdAsync(${namePrimaryKey});
            if (entity == null)
            {
                return null;
            }
            return Mapper.Map<${className}>(entity);
        }

        public async Task<${className}> InsertAsync(${className} model)
        {
            var entity = Mapper.Map<${className}Entity>(model);
            var createdEntity = await _localRepository${className}.InsertAsync(entity);
            return Mapper.Map<${className}>(createdEntity);
        }

        public async Task<${className}> UpdateAsync(${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey}, ${className} model)
        {
            var entity = await _localRepository${className}.GetByIdAsync(${namePrimaryKey});
            if (entity == null)
            {
                return null;
            }

            Mapper.Map(model, entity);
            var updatedEntity = await _localRepository${className}.UpdateAsync(entity);
            return Mapper.Map<${className}>(updatedEntity);
        }

        public async Task<object> DeleteAsync(${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey})
        {
            var entity = await _localRepository${className}.GetByIdAsync(${namePrimaryKey});
            if (entity == null)
            {
                return null;
            }

            return await _localRepository${className}.DeleteAsync(entity.${castToPascalCase(primaryKeyField.Atributo)});
        }
    }
}`;
  fs.writeFileSync(`Generated/${baseNamespace}/Services/${className}Service.cs`, content);
}


function generateController(className, primaryKeyField) {
  const namePrimaryKey = primaryKeyField ? castCamelCase(primaryKeyField.Atributo) : "id";
  const controllerName = `${className}Controller`;
  const modelName = className;
  const varname = lowerFirstLetter(className);
  const serviceInterface = `${className}Service`;
  const repositoryInterface = `${className}Repository`;

  const content = `using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Newtonsoft.Json;
using Aperam.${baseNamespace}.API.Utils;
using Aperam.${baseNamespace}.Domain.Entities;
using Aperam.${baseNamespace}.Domain.Service;

namespace Aperam.${baseNamespace}.API.Controllers
{
    /// <summary>
    /// Inicializa uma nova instância da classe ${controllerName}.
    /// </summary>
    [Route("api/${modelName}")]
    public class ${controllerName} : BaseController
    {
        private ${serviceInterface} _local${className}Service = null;
        
        /// <summary>
        /// Construtor para ${controllerName}.
        /// </summary>
        public ${controllerName}()
        {
            _local${className}Service = new ${serviceInterface}();
        }
        
        #region Métodos públicos ${modelName}
        
        
        /// <summary>
        /// Método para obter todos os registros de ${modelName}.
        /// </summary>
        [HttpGet, Route("GetAll")]
        public async Task<HttpResponseMessage> GetAll()
        {
            try
            {
              var ${modelName.toLowerCase()}List = await _local${className}Service.GetAllAsync();
              return HttpMessages.OK(Request, JsonConvert.SerializeObject(${modelName.toLowerCase()}List));
            }
            catch (System.Exception ex)
            {
                return HttpMessages.BadRequest(Request, ex.Message);
            }
        }
        
        /// <summary>
        /// Método para obter um registro de ${modelName} por ID.
        /// </summary>
        [HttpGet, Route("GetOne")]
        public async Task<HttpResponseMessage> GetOne([FromUri] ${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey})
        {
            try
            {
              var ${modelName.toLowerCase()} = await _local${className}Service.GetByIdAsync(${namePrimaryKey});
              if (${modelName.toLowerCase()} == null)
              {
                  return HttpMessages.BadRequest(Request, new { Message = "Registro não encontrado!" });
              }
              return HttpMessages.OK(Request, JsonConvert.SerializeObject(${modelName.toLowerCase()}));
            }
            catch (System.Exception ex)
            {
                return HttpMessages.BadRequest(Request, ex.Message);
            }
        }
        /// <summary>
        /// Método para inserir um registro de ${modelName}.
        /// </summary>
        [HttpPost, Route("Insert")]
        public async Task<HttpResponseMessage> Post([FromBody] ${modelName} ${modelName.toLowerCase()})
        {
            try
            {
              if (${modelName.toLowerCase()} == null)
              {
                  return HttpMessages.BadRequest(Request, new { Message = "Registro não encontrado!" });
              }
              
              await _local${className}Service.InsertAsync(${modelName.toLowerCase()});
              return HttpMessages.OK(Request, new { Message = "Registro inserido com sucesso!" });
            }
            catch (System.Exception ex)
            {
                return HttpMessages.BadRequest(Request, ex.Message);
            }
        }
        /// <summary>
        /// Método para atualizar um registro de ${modelName}.
        /// </summary>
        [HttpPut, Route("Update")]
        public async Task<HttpResponseMessage> Put([FromUri] ${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey}, [FromBody] ${modelName} ${modelName.toLowerCase()})
        {
            try
            {
              if (${modelName.toLowerCase()} == null || ${modelName.toLowerCase()}.${castToPascalCase(primaryKeyField.Atributo)} != ${namePrimaryKey})
              {
                  return HttpMessages.BadRequest(Request, new { Message = "Registro não encontrado!" });
              }

              var ${modelName.toLowerCase()}Old = await _local${className}Service.GetByIdAsync(${namePrimaryKey});
              if (${modelName.toLowerCase()}Old == null)
              {
                  return HttpMessages.BadRequest(Request, new { Message = "Registro não encontrado!" });
              }

              await _local${className}Service.UpdateAsync(${namePrimaryKey}, ${modelName.toLowerCase()});
              return HttpMessages.OK(Request, new { Message = "Registro atualizado com sucesso!" });
            }
            catch (System.Exception ex)
            {
                return HttpMessages.BadRequest(Request, ex.Message);
            }
        }
        
        /// <summary>
        /// Método para excluir um registro de ${modelName}.
        /// </summary>
        [HttpDelete, Route("Delete")]
        public async Task<HttpResponseMessage> Delete([FromUri] ${typeMapping[primaryKeyField.Tipo] || "int"} ${namePrimaryKey})
        {
            try
            {
              var ${modelName.toLowerCase()} = await _local${className}Service.GetByIdAsync(${namePrimaryKey});
              if (${modelName.toLowerCase()} == null)
              {
                  return HttpMessages.BadRequest(Request, new { Message = "Registro não encontrado!" });
              }

              await _local${className}Service.DeleteAsync(${namePrimaryKey});
              return HttpMessages.OK(Request, new { Message = "Registro excluído com sucesso!" });
            }
            catch (System.Exception ex)
            {
                return HttpMessages.BadRequest(Request, ex.Message);
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

          const converted = JSON.parse(data);

          let primaryKeyField = converted.find(field => field.Obrigatoriedade && field.Obrigatoriedade.toLowerCase().includes("primary key"));
          !primaryKeyField ? primaryKeyField = converted[0] : null;

          generateRepositoryInterface(className);
          generateServiceInterface(className);
          generateService(className, primaryKeyField);
          generateRepository(className, data);
          generateController(className, primaryKeyField);
          generateValidationFile(className, data);
          generateEntityFile(className, data);
          generateModelFile(className, data);
          generateViewModel(className, data);
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
