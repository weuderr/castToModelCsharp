const fs = require('fs');
const path = require('path');
const {faker} = require('@faker-js/faker');

function splitCsvLine(line) {
    const regex = /(?:^|,)("(?:[^"]+)*"|[^,]*)/g;
    let match;
    const fields = [];

    while ((match = regex.exec(line)) !== null) {
        let matchedValue = match[1];
        matchedValue = matchedValue.startsWith('"') && matchedValue.endsWith('"')
            ? matchedValue.slice(1, -1) // remove as aspas
            : matchedValue.trim();
        fields.push(matchedValue);
    }

    return fields;
}

function toUpperSnakeCase(name) {
    return name
        .split(/(?=[A-Z])/)
        .join('_')
        .toUpperCase();
}

function camelCaseReName(name) {
    return name
        .toLowerCase()
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join('');
}

function abreviateName(name) {
    return name
        .toLowerCase()
        .split('_')
        .map(word => word.charAt(0).toUpperCase())
        .join('');
}

function injectForeignKeyReferences(folderPath) {
    const files = fs.readdirSync(folderPath);
    const foreignKeyReferences = {};

    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const lines = fileData.split('\n');
            lines.shift(); // remove header

            lines.forEach(line => {
                if (line === '') return;
                const fields = splitCsvLine(line);
                if (fields[2] && fields[2].startsWith('FK:')) {
                    const relatedTable = fields[2].split(':')[1];
                    const currentTable = camelCaseReName(path.basename(file, '.csv'));

                    if (!foreignKeyReferences[relatedTable]) {
                        foreignKeyReferences[relatedTable] = [];
                    }

                    foreignKeyReferences[relatedTable].push(currentTable);
                }
            });
        }
    });

    Object.entries(foreignKeyReferences).forEach(([table, references]) => {
        const edmxModelFilePath = path.join(__dirname, 'edmxModel', `${table}.cs`);

        if (fs.existsSync(edmxModelFilePath)) {
            let edmxModelCode = fs.readFileSync(edmxModelFilePath, 'utf8');

            let insertCode = '';  // This will hold the navigation properties to be inserted

            references.forEach(reference => {
                const propertyName = `${reference}`; // Pluralize
                const referenceTableName = toUpperSnakeCase(propertyName);
                const instanceCode = `            this.${referenceTableName} = new HashSet<${referenceTableName}>();\n`;

                const constructorStart = new RegExp(`public ${table}\\(\\)\\s*{`);
                const constructorEnd = new RegExp(`public ${table}\\(\\)\\s*{[^}]*}`, 's');
                const navigationPropertyCode = `        public virtual ICollection<${referenceTableName}> ${referenceTableName} { get; set; }\n`;

                if (edmxModelCode.match(constructorStart)) {
                    // Se já existe um construtor, adicione ao final deste construtor
                    edmxModelCode = edmxModelCode.replace(constructorEnd, match => {
                        return match.replace('        }', `${instanceCode}        }`);
                    });
                } else {
                    // Se não houver construtor, crie um
                    edmxModelCode = edmxModelCode.replace(new RegExp(`public partial class ${table}\\s*{`), `public partial class ${table}\n    {\n        public ${table}()\n        {\n${instanceCode}        }\n`);
                }

                if (!edmxModelCode.includes(navigationPropertyCode)) {  // To ensure we don't add duplicate navigation properties
                    insertCode += navigationPropertyCode;  // Append to the insertCode
                }
            });

            // Now, let's insert the navigation properties before the last closing brace
            edmxModelCode = edmxModelCode.replace(/}\s*}\s*$/, insertCode + '    }\n}');

            fs.writeFileSync(edmxModelFilePath, edmxModelCode, 'utf8');
        } else {
            console.warn(`[WARNING] File ${edmxModelFilePath} not found. Skipping reference injection for this model.`);
        }
    });
}

function getCsharpTypeFromSqlType(type) {
    if (type.startsWith('NUMBER')) {
        if (type.includes('(') && type.includes(',')) {
            return 'decimal';
        } else {
            return 'int';
        }
    } else if (type.startsWith('VARCHAR')) {
        return 'string';
    } else if (type === 'DATE') {
        return 'DateTime';
    } else if (type === 'CLOB') {
        return 'string';
    } else {
        return 'object'; // default to a generic object type
    }
}

function getCsharpTypeFromEdmxSqlType(type) {
    if (type === 'AUTOINCREMENT' || type.startsWith('NUMBER')) {
        if (type.includes('(') && type.includes(',')) {
            var size = type.split('(')[1].split(',')[0];
            var decimalPlaces = type.split(',')[1].split(')')[0];
            if (decimalPlaces > 0) {
                return 'decimal';
            } else {
                if (size > 10) {
                    return 'long';
                } else {
                    return 'int';
                }
            }
        } else {
            return 'int';
        }
    } else if (type.startsWith('VARCHAR2')) {
        return 'string';
    } else if (type === 'DATE') {
        return 'DateTime';
    } else {
        return 'string'; // default
    }
}


function csvToCsharpViewModel(csvData, modelName) {
    const lines = csvData.split('\n');
    lines.shift();

    let modelCode = 'using System;\n' +
        'using System.ComponentModel.DataAnnotations;\n\n' +
        'namespace Aperam.PCP.PNV.UI.ViewModels\n{\n';
    modelCode += `    public class ${modelName}ViewModel\n    {\n`;

    lines.forEach(line => {
        if (line === '') return;
        const fields = splitCsvLine(line);

        if (fields[0]) {
            const columnName = fields[0];
            const type = fields[1];
            const notNull = fields[2];
            const nameField = fields[3];
            const allowedValues = fields[4];

            let csharpType = '';
            csharpType = getCsharpTypeFromSqlType(type);

            if (notNull !== 'YES' && notNull !== 'PK' && csharpType !== 'string') {
                csharpType += '?';
            }

            if (nameField) {
                modelCode += `        [Display(Name = "${nameField}")]\n`;
            }

            if (notNull === 'YES') {
                modelCode += `        [Required(ErrorMessage = "O campo ${nameField} é obrigatório.")]\n`;
            }

            if (allowedValues) {
                const escapedValues = allowedValues.split('|').map(value => value.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')).join('|');
                modelCode += `        [RegularExpression("^([${escapedValues.replace(",","")}])+$", ErrorMessage = "O campo ${nameField} deve conter um dos seguintes valores: (${allowedValues})")]`;
            }

            // Adicione o atributo [StringLength] com base no tamanho máximo
            if (type.startsWith('VARCHAR') && type.includes('(')) {
                const maxLength = type.split('(')[1].split(')')[0];
                modelCode += `        [StringLength(${maxLength}, ErrorMessage = "O campo ${nameField} não pode ter mais de ${maxLength} caracteres.")]\n`;
            }

            if (fields[2] === 'FK') {
                modelCode += `        [ForeignKey("${columnName}")]\n`;
            }

            modelCode += `        public ${csharpType} ${columnName} { get; set; }\n\n`;
        }
    });

    modelCode += '    }\n}';
    return modelCode;
}


function csvToEdmxModel(csvData, modelName) {
    const lines = csvData.split('\n');
    lines.shift();

    let modelCode = 'namespace Aperam.PCP.PNV.Negocio.Modelos\n' +
        '{\n    using System;' +
        '\n    using System.Collections.Generic;\n\n';
    modelCode += `    public partial class ${modelName}\n    {\n`;

    const navigationProperties = [];

    let instanceForeignKey = '';
    let modelCodeBody = '';

    lines.forEach(line => {
        if (line === '') return;
        const fields = splitCsvLine(line);

        if (fields[0]) {
            const columnName = fields[0];
            const type = fields[1];
            const notNull = fields[2];

            let csharpType = '';

            csharpType = getCsharpTypeFromEdmxSqlType(type);

            // Se o campo Not Null for YES, tornamos o tipo nullable
            if (notNull === 'YES' && ['int', 'DateTime'].includes(csharpType)) {
                csharpType += '?';
            }

            modelCodeBody += `        public ${csharpType} ${columnName} { get; set; }\n`;

            if (notNull && notNull.startsWith('FK:')) {
                const relatedTable = notNull.split(':')[1];
                navigationProperties.push(`\n        public virtual ${relatedTable} ${relatedTable} { get; set; }\n`);
                // instanceForeignKey += `    ${columnName} = new HashSet<${relatedTable}>();\n`;
            }
        }
    });

    // modelCode += `        public ${modelName}()\n        {
    //     ${instanceForeignKey}        }\n\n`;

    modelCode += modelCodeBody;

    // Adiciona propriedades de navegação ao modelo
    navigationProperties.forEach(np => {
        modelCode += np;
    });

    modelCode += '    }\n}';

    return modelCode;
}


function generateRelationsGetListWithObject(tableName, primaryKey, foreignKeys) {
    const joinQueries = [];

    foreignKeys.forEach((fk) => {
        const joinAlias = fk.referencedTable.split('_').map(word => word.charAt(0)).join('');
        let gets = '';
        const localTableName = camelCaseReName(fk.referencedTable);
        if (fk.nullable) {
            gets = `\n
                        if(getRelations.Contains("${fk.referencedTable}") && values != null && values.${fk.referencedColumn} != null) {
                            string sql${localTableName} = "SELECT * FROM ${fk.referencedTable}";
                            sql${localTableName} += " WHERE ${fk.referencedColumn} = " + values.${fk.referencedColumn};
                            DataTable dt${localTableName} = acessoDados.ExecuteDatatable(sql${localTableName});
                            
                            if (dt${localTableName} != null && dt${localTableName}.Rows.Count > 0) {
                                var list = new List<${fk.referencedTable}>();
                                foreach (DataRow row in dt${localTableName}.Rows) {
                                    var item = Utils.MapDataRowToObject<${fk.referencedTable}>(row);
                                    list.Add(item);
                                }
                                values.${fk.referencedTable} = list;
                            }
                        }`;
            joinQueries.push(gets);
        }

    });

    return joinQueries.join(' ');
}

function generateGetListWithObjectQuery(tableName, columns, primaryKey, foreignKeys) {
    const joinQueries = [];
    const camelCaseTableName = camelCaseReName(tableName);

    foreignKeys.forEach((fk) => {
        if (tableName === fk.referencedTable) return;
        let getForingKey = '';
        const localTableName = camelCaseReName(fk.referencedTable);
        if (!fk.nullable) {
            getForingKey = `if(getRelations.Contains("${fk.referencedTable}") && model.${fk.referencedColumn} != null) {
                                ${fk.referencedTable} rt${localTableName} = new ${localTableName}Bll().Get${localTableName}ById(model.${fk.referencedColumn}, getRelations);
                                if (rt${localTableName} != null && rt${localTableName}.${fk.referencedColumn} != null) {
                                    model.${fk.referencedTable} = rt${localTableName};
                                }
                            }`;

            joinQueries.push(getForingKey);
        }

    });

    let relationsForList = generateRelationsGetListWithObject(tableName, primaryKey, foreignKeys);
    const columnsLikeAnexo = columns.filter(column => column.toLowerCase().includes('anex'));
    const stringColumns = columnsLikeAnexo.map(column => `if (!row${camelCaseTableName}.Table.Columns.Contains("${column}"))\nrow${camelCaseTableName}.Table.Columns.Remove("${column}");`).join('\n');

    let valueReturn = `strSql.Append(" SELECT * ");\n`;
    valueReturn += `                        strSql.Append(" FROM ${tableName} ");\n`;
    valueReturn += `foreach (PropertyDescriptor property in TypeDescriptor.GetProperties(queryObj))
                        {
                            var value = property.GetValue(queryObj);
                            if (value != null)
                            {
                                string sanitizedValue = value.ToString().Replace("'", "''");
                                if(sqlWhere == "")
                                    sqlWhere = $" WHERE {property.Name} = '{sanitizedValue}'";
                                else
                                    sqlWhere += $" AND {property.Name} = '{sanitizedValue}'";
                            }
                        }
                        strSql.Append(sqlWhere);
                        DataTable dt${camelCaseTableName} = acessoDados.ExecuteDatatable( strSql.ToString() );
                        List<${tableName}> model = new List<${tableName}>();
                        `;
    valueReturn += `
                        if (dt${camelCaseTableName}.Rows.Count > 0 ) {
                            foreach (DataRow row${camelCaseTableName} in dt${camelCaseTableName}.Rows) {
                                ${stringColumns}
                                var values = Utils.MapDataRowToObject<${tableName}>(row${camelCaseTableName});

                                //Inicio da busca de relacionamentos
                                ${relationsForList}
                                model.Add(values);
                            }
                        } else {
                            return null;
                        }`;


    return valueReturn;
}


function generateRelationsForGetByID(tableName, primaryKey, foreignKeys) {
    const joinQueries = [];

    foreignKeys.forEach((fk) => {
        const joinAlias = fk.referencedTable.split('_').map(word => word.charAt(0)).join('');
        let gets = '';
        const localTableName = camelCaseReName(fk.referencedTable);
        if (fk.nullable) {
            gets = `\n
                        if(getRelations.Contains("${fk.referencedTable}") && model != null && model.${fk.referencedColumn} != null) {
                            string sql${localTableName} = "SELECT * FROM ${fk.referencedTable}";
                            sql${localTableName} += " WHERE ${fk.referencedColumn} = " + model.${fk.referencedColumn};
                            DataTable dt${localTableName} = acessoDados.ExecuteDatatable(sql${localTableName});
                            
                            if (dt${localTableName} != null && dt${localTableName}.Rows.Count > 0) {
                                var list = new List<${fk.referencedTable}>();
                                foreach (DataRow row in dt${localTableName}.Rows) {
                                    var item = Utils.MapDataRowToObject<${fk.referencedTable}>(row);
                                    list.Add(item);
                                }
                                model.${fk.referencedTable} = list;
                            }
                        }`;
            joinQueries.push(gets);
        }

    });

    return joinQueries.join(' ');
}

function generateSelectGetById(tableName, primaryKey, foreignKeys) {
    const joinQueries = [];
    const camelCaseTableName = camelCaseReName(tableName);

    foreignKeys.forEach((fk) => {
        let getForingKey = '';
        const localTableName = camelCaseReName(fk.referencedTable);
        if (!fk.nullable) {
            getForingKey = `if(getRelations.Contains("${fk.referencedTable}") && model.${fk.referencedColumn} != null) {
                                ${fk.referencedTable} rt${localTableName} = new ${localTableName}Bll().Get${localTableName}ById(model.${fk.referencedColumn}, getRelations);
                                if (rt${localTableName} != null && rt${localTableName}.${fk.referencedColumn} != null) {
                                    model.${fk.referencedTable} = rt${localTableName};
                                }
                            }`;

            joinQueries.push(getForingKey);
        }

    });
    // let valueReturn = `strSql.Append("SELECT * FROM ${tableName} ${mainTableAlias} WHERE ${mainTableAlias}.${primaryKey} = " + ${primaryKey} + ";");\n`;
    let valueReturn = `strSql.Append(" SELECT * ");\n`;
    valueReturn += `                        strSql.Append(" FROM ${tableName} ");\n`;
    valueReturn += `                        strSql.Append(" WHERE ${primaryKey} = " + ${primaryKey} );\n`;
    valueReturn += `                        DataTable dt${camelCaseTableName} = acessoDados.ExecuteDatatable( strSql.ToString() );\n`;
    valueReturn += `                        ${tableName} model = new ${tableName}();\n`;
    valueReturn += `
                        if (dt${camelCaseTableName}.Rows.Count > 0 ) {
                            model = Utils.MapDataRowToObject<${tableName}>(dt${camelCaseTableName}.Rows[0]);
                            ${joinQueries.join(' ')}
                        }`;


    return valueReturn;
}

function generateGetById(modelName, primaryKey, foreignKeys) {
    const tableName = toUpperSnakeCase(modelName);
    let selectStatements = generateSelectGetById(tableName, primaryKey, foreignKeys)
    let selects = generateRelationsForGetByID(tableName, primaryKey, foreignKeys)

    return `public ${tableName} GetById(int ${primaryKey}, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        ${selectStatements}
                        if(!string.IsNullOrEmpty(getRelations))
                        {
                            ${selects}
                        }
    
                        return model;
                    }
                } 
                catch (OracleException ex) 
                {
                    throw new Exception("Erro ao buscar dados na tabela ${tableName} com a query.", ex);
                }
            }`;
}

function generateGetListWithObject(modelName, columns, primaryKey, foreignKeys) {
    const tableName = toUpperSnakeCase(modelName);
    let selectStatementsForList = generateGetListWithObjectQuery(tableName, columns, primaryKey, foreignKeys);

    return `public List<${tableName}> GetWithObject(object queryObj, string getRelations = "")
            {
                try 
                {
                    StringBuilder strSql = new StringBuilder();
                    var sqlWhere = String.Empty;
                    using (var acessoDados = new AcessoDadosOracle())
                    {
                        ${selectStatementsForList}
    
                        return model;
                    }
                } 
                catch (OracleException ex)
                {
                    throw new Exception("Erro ao buscar dados na tabela ${tableName} com a query.", ex);
                }
            }`;
}

function generateDalWithPureSql(modelName, columns, primaryKey, foreignKeys) {
    const tableName = toUpperSnakeCase(modelName);
    const getByIdMethod = generateGetById(modelName, primaryKey, foreignKeys);
    const getWithObjectMethod = generateGetListWithObject(modelName, columns, primaryKey, foreignKeys);


    return `using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.ComponentModel;
using Aperam.PCP.PNV.BusinessLogic;
using Aperam.Biblioteca.DataBase;
using Aperam.PCP.PNV.Negocio.Base;
using Aperam.PCP.PNV.Negocio.Modelos;
using Oracle.DataAccess.Client;

namespace Aperam.PCP.PNV.DataAccess
{
    public class ${modelName}Dal
    {
        // Create ${modelName}
        public int Insert(dynamic values)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateInsertQuery("${tableName}", values, "${primaryKey}");
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao inserir dados na tabela ${tableName}. Detalhes do erro: " + ex.Message, ex);
            }
        }
        
        // Update ${modelName}
        public int Update(dynamic model)
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = Utils.GenerateUpdateQuery("${tableName}", model, "${primaryKey}", model.${primaryKey});
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao atualizar dados na tabela ${tableName}. Detalhes do erro: " + ex.Message, ex);
            }
        }

        
        // Read ${modelName}
        ${getByIdMethod}
        
        // Read With Query ${modelName}
        ${getWithObjectMethod}

        // Delete ${modelName}
        public int Delete(int ${primaryKey})
        {
            try 
            {
                using (var acessoDados = new AcessoDadosOracle())
                {
                    string sql = "DELETE FROM ${tableName} WHERE ${primaryKey} = " + ${primaryKey};
                    return acessoDados.ExecuteNonQuery(sql);
                }
            } 
            catch (OracleException ex)
            {
                throw new Exception("Erro ao deletar dados na tabela ${tableName}. Detalhes do erro: " + ex.Message, ex);
            }
        }
    }
}`;
}


function getForeignKeyFromAllFiles(folderPath, currentTableName) {
    const files = fs.readdirSync(folderPath);
    let foreignKeys = [];
    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const lines = fileData.split('\n');

            const modelName = camelCaseReName(path.basename(file, '.csv'));
            const tableName = toUpperSnakeCase(modelName);

            lines.shift();

            if (tableName !== currentTableName) {
                lines.forEach(line => {
                    if (line.trim() === '') return;
                    const fields = splitCsvLine(line);

                    // Considerando chaves estrangeiras em todos os arquivos.
                    if (fields[2] && fields[2].startsWith('FK:') && fields[2].split(':')[1] === currentTableName) {
                        foreignKeys.push({
                            column: fields[0],
                            table: currentTableName,
                            referencedTable: tableName,
                            referencedColumn: fields[0],
                            nullable: true
                        });
                    }
                });
            } else {
                lines.forEach(line => {
                    if (line.trim() === '') return;
                    const fields = splitCsvLine(line);

                    // Considerando chaves estrangeiras em todos os arquivos.
                    if (fields[2] && fields[2].startsWith('FK:')) {
                        foreignKeys.push({
                            column: fields[0],
                            referencedTable: fields[2].split(':')[1],
                            referencedColumn: fields[0],
                            nullable: false
                        });
                    }
                });
            }
        }
    });
    return foreignKeys;
}

function generateBllClass(tableName, modelName) {
    let bllCode = 'using System.Collections.Generic;\n' +
        `using Aperam.PCP.PNV.DataAccess;\n` +
        `using Aperam.PCP.PNV.Negocio.Modelos;\n\n` +
        `namespace Aperam.PCP.PNV.BusinessLogic\n{\n` +
        `    public class ${modelName}Bll\n    {\n` +
        `        private readonly ${modelName}Dal _${modelName}Dal;\n\n` +
        `        public ${modelName}Bll()\n        {\n` +
        `            _${modelName}Dal = new ${modelName}Dal();\n` +
        `        }\n\n` +
        `        public ${tableName} Get${modelName}ById(int id, string getRelations = "")\n        {\n` +
        `            return _${modelName}Dal.GetById(id, getRelations);\n` +
        `        }\n\n` +
        `        public List<${tableName}> Get${modelName}WithObject(object queryObj, string getRelations = "")\n        {\n` +
        `            return _${modelName}Dal.GetWithObject(queryObj, getRelations);\n` +
        `        }\n\n` +
        `        public int Add${modelName}(dynamic entity)\n        {\n` +
        `            return _${modelName}Dal.Insert(entity);\n` +
        `        }\n\n` +
        `        public int Update${modelName}(dynamic entity)\n        {\n` +
        `            return _${modelName}Dal.Update(entity);\n` +
        `        }\n\n` +
        `        public int Delete${modelName}(int id)\n        {\n` +
        `            return _${modelName}Dal.Delete(id);\n` +
        `        }\n` +
        '    }\n' +
        '}';

    return bllCode;
}

function generateDalClassesForAllModels(folderPath) {
    const files = fs.readdirSync(folderPath);
    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const modelName = camelCaseReName(path.basename(file, '.csv'));
            const tableName = toUpperSnakeCase(modelName);
            const lines = fileData.split('\n');
            lines.shift();

            let columns = [];
            let primaryKey = null;

            lines.forEach(line => {
                if (line.trim() === '') return;
                const fields = splitCsvLine(line);
                if (fields[0] && fields[2] === "PK") {
                    primaryKey = fields[0];
                }
                if (fields[0]) {
                    columns.push(fields[0]);
                }
            });

            if (!primaryKey) {
                console.error(`Erro: A chave primária não foi definida para o modelo ${modelName}.`);
                return;
            }

            const foreignKeys = getForeignKeyFromAllFiles(folderPath, tableName);

            const dalCode = generateDalWithPureSql(modelName, columns, primaryKey, foreignKeys);
            const bllCode = generateBllClass(tableName, modelName);

            // Escreva a classe DAL em um arquivo na pasta 'DataAccess'
            const dalPath = path.join(__dirname, 'DataAccess', `${modelName}Dal.cs`);
            fs.writeFileSync(dalPath, dalCode, 'utf8');
            console.log(`Classe DAL ${modelName}Dal.cs criada com sucesso!`);


            // Escreva a classe BLL em um arquivo na pasta 'BusinessLogic'
            const bllPath = path.join(__dirname, 'BusinessLogic', `${modelName}Bll.cs`);
            fs.writeFileSync(bllPath, bllCode, 'utf8');
            console.log(`Classe BLL ${modelName}Bll.cs criada com sucesso!`);
        }
    });
}


function getRandomValueByColumnType(columnType, values = null) {
    if(values) {
        const valuesArray = values.split(',');
        const randomIndex = Math.floor(Math.random() * valuesArray.length);
        return valuesArray[randomIndex].replace(/\s/g, '');
    }
    columnType = columnType.toLowerCase();
    if (columnType.includes('int') || columnType.includes('number')) {
        if (columnType.includes('(')) {
            const getSize = columnType.split('(')[1].split(')')[0];
            const sizeChars = getSize ? parseInt(getSize.split(',')[0]) : 1;
            const decimalPlaces = getSize ? parseInt(getSize.split(',')[1]) : 0;
            if (decimalPlaces > 0) {
                let number = faker.number.float({
                    min: 1,
                    max: sizeChars
                });
                number = number.toFixed(decimalPlaces);
                return (number) * 1;
            } else {
                return faker.number.int({
                    min: 1,
                    max: sizeChars
                });
            }
        } else {
            // not can be negative or zero
            return faker.number.int({
                min: 1,
                max: 9
            });
        }
    } else if (columnType.includes('varchar')) {
        const getSize = columnType.split('(')[1].split(')')[0];
        let sizeChars = getSize ? parseInt(getSize) : 1;

        if (sizeChars > 5) sizeChars = sizeChars - 2;
        if (sizeChars > 1000) return faker.lorem.paragraph();
        if (sizeChars > 100) return faker.lorem.sentence();
        if (sizeChars > 50) return faker.lorem.words();
        if (sizeChars > 10) return faker.lorem.word();

        return faker.string.alpha(sizeChars);
    } else if (columnType.includes('DateTime') || columnType.includes('date')) {
        return faker.date.past();
    } else {
        return '';
    }

}

function generatePostmanRequestsForModel(modelName, columns, columnTypes, primaryKey, foreignKeys) {
    const baseApiUrl = 'http://localhost:61112';
    const requests = [];
    const stringifiedForeignKeys = foreignKeys.map(fk => `${fk.referencedTable}`).join(',');

    // SELECT (GET One)
    const valuesOfGet = {key: primaryKey, value: getRandomValueByColumnType('int'), type: 'text'}
    requests.push({
        id: faker.string.uuid(),
        name: `Busca - ${modelName} por ID`,
        method: 'GET',
        url: `${baseApiUrl}/${modelName}/GetData?${primaryKey}=${valuesOfGet.value}&relations=${stringifiedForeignKeys}`,
        query: [
            valuesOfGet,
            {
                relations: stringifiedForeignKeys
            }
        ],
        dataMode: 'params'
    });

    const searchByPostBody = columns.map((column, index) => {
        // lower case
        if (column.toLowerCase() !== primaryKey.toLowerCase()) return;
        const columnType = columnTypes[index][1];
        return {
            key: column,
            value: getRandomValueByColumnType(columnType),
            type: 'text'
        };
    }).filter(Boolean);
    requests.push({
        id: faker.string.uuid(),
        name: `Busca - ${modelName} com body`,
        method: 'POST',
        url: `${baseApiUrl}/${modelName}/GetListDataWithObject?relations=${stringifiedForeignKeys}`,
        headerData: [{key: 'Content-Type', value: 'application/json'}],
        data: searchByPostBody,
        query: [
            valuesOfGet,
            {
                relations: stringifiedForeignKeys
            }
        ],
        dataMode: 'raw',
        rawModeData: JSON.stringify(searchByPostBody.reduce((obj, column, index) => {
            const columnType = columnTypes[index][1];
            return {...obj, [column.key]: getRandomValueByColumnType(columnType)}
        }, {}), null, 2),
    });

    // INSERT (POST)
    const insertData = columns.map((column, index) => {
        const columnType = columnTypes[index][1];
        const values = columnTypes[index][2];
        return {
            key: column,
            value: getRandomValueByColumnType(columnType, values),
            type: 'text'
        };
    });

    // raw - JSON
    requests.push({
        id: faker.string.uuid(),
        name: `Cria - ${modelName}`,
        method: 'POST',
        url: `${baseApiUrl}/${modelName}/CreateData`,
        headerData: [{key: 'Content-Type', value: 'application/json'}],
        data: insertData,
        dataMode: 'raw',
        rawModeData: JSON.stringify(columns.reduce((obj, column, index) => {
            const columnType = columnTypes[index][1];
            const values = columnTypes[index][2];
            return {...obj, [column]: getRandomValueByColumnType(columnType, values)}
        }, {}), null, 2),
    });

    // UPDATE (PUT)
    let updateData = columns.filter(column => column !== primaryKey).map((column, index) => {
        const columnType = columnTypes[index][1];
        return {
            key: column,
            value: getRandomValueByColumnType(columnType),
            type: 'text'
        };
    });

    updateData[`"${primaryKey}"`] = valuesOfGet.value;

    let rawModeData = JSON.stringify(columns.reduce((obj, column, index) => {
        const columnType = columnTypes[index][1];
        return {...obj, [column]: getRandomValueByColumnType(columnType)}
    }, {}), null, 2);

    rawModeData = rawModeData.replace(`"${primaryKey}":`, `"${primaryKey}": ${valuesOfGet.value},`);

    requests.push({
        id: faker.string.uuid(),
        name: `Atualiza - ${modelName}`,
        method: 'PUT',
        url: `${baseApiUrl}/${modelName}/UpdateData`,
        headerData: [{key: 'Content-Type', value: 'application/json'}],
        data: updateData,
        dataMode: 'raw',
        // query: [valuesOfGet],
        rawModeData: rawModeData
    });

    // DELETE (DELETE)
    const valuesOfDelete = {key: primaryKey, value: getRandomValueByColumnType('int'), type: 'text'}
    requests.push({
        id: faker.string.uuid(),
        name: `Remove - ${modelName}`,
        headerData: [{key: 'Content-Type', value: 'application/json'}],
        method: 'DELETE',
        url: `${baseApiUrl}/${modelName}/DeleteData?${primaryKey}=${valuesOfDelete.value}`,
        query: [valuesOfDelete],
        dataMode: 'params'
    });

    return requests;
}

function generatePostmanCollectionForAllModels(folderPath) {
    const collection = {
        id: faker.string.uuid(),
        name: 'CVTP - Collection',
        description: '',
        order: [],
        folders: [],
        requests: []
    };

    const files = fs.readdirSync(folderPath);
    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const modelName = camelCaseReName(path.basename(file, '.csv'));
            const tableName = toUpperSnakeCase(modelName);
            const lines = fileData.split('\n');
            lines.shift();

            let columns = [];
            let columnsMoreTypes = [];
            let primaryKey = null;

            lines.forEach(line => {
                if (line.trim() === '') return;
                const fields = splitCsvLine(line);
                if (fields[0] && fields[2] === "PK") {
                    primaryKey = fields[0];
                }
                if (fields[0]) {
                    columns.push(fields[0]);
                    columnsMoreTypes.push([fields[0], fields[1], fields[4]]);
                }
            });

            if (!primaryKey) {
                console.error(`Erro: A chave primária não foi definida para o modelo ${modelName}.`);
                return;
            }

            const foreignKeys = getForeignKeyFromAllFiles(folderPath, tableName);

            const requests = generatePostmanRequestsForModel(modelName, columns, columnsMoreTypes, primaryKey.toLowerCase(), foreignKeys);

            const folderId = faker.string.uuid();
            collection.folders.push({
                id: folderId,
                name: modelName,
                description: "",
                order: requests.map(r => r.id),
            });

            collection.requests = collection.requests.concat(requests.map(req => {
                req.folder = folderId;
                return req;
            }));
        }
    });

    fs.writeFileSync(path.join(__dirname, 'cvtp-postman-collection.json'), JSON.stringify(collection, null, 2), 'utf8');
}


function generateControllerForModel(folderPath, modelName, modelNameCamelCase, primaryKey, columns) {
    // Define o nome BLL (Business Logic Layer) para o modelo.
    const bllName = `${modelNameCamelCase}Bll`;

    function findColumnWithRegex(columns, findFor) {
        const parts = findFor.split('_');
        const firstPart = parts[0].substr(0, 3);
        const secondPart = parts[1].substr(0, 3);
        // can exist in order or not
        const regex = new RegExp(`^${firstPart}.*${secondPart}$`, 'i');
        const column = columns.find(col => regex.test(col));
        return column;
    }

    // Constrói a estrutura do controlador
    return `using System;
using Aperam.Biblioteca.Util.Base.Entidades;
using Aperam.Biblioteca.Util.Base.MVC;
using System.Collections.Generic;
using System.IO;
using System.Web.Mvc;
using Aperam.PCP.PNV.BusinessLogic;
using Aperam.PCP.PNV.UI.ViewModels;
using Newtonsoft.Json;

namespace Aperam.PCP.PNV.UI.Controllers
{
    [HandleError]
    public class ${modelNameCamelCase}Controller : ControleBase
    {
        #region Propriedades
            String NomeExecutavel = String.Empty;
            ${bllName} acessaDados = null;
            UtilsController utils = null;
        #endregion
        
        #region Construtor
            public ${modelNameCamelCase}Controller()
            {
                this.NomeExecutavel = "PNMBI009";
                this.acessaDados = new ${bllName}();
                this.utils = new UtilsController();
            }
        #endregion
        
        #region Verbos HTTP
        
            /// <summary>
            /// Método responsável por retornar os dados de ${modelNameCamelCase}
            /// </summary>
            /// <param name="${primaryKey.toLowerCase()}"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpGet]
            public JsonResult GetData(string ${primaryKey.toLowerCase()} = "", string relations = "")
            {
                if (!string.IsNullOrEmpty(${primaryKey.toLowerCase()}))
                {
                    try
                    {
                        var value = Convert.ToInt32(${primaryKey.toLowerCase()});
                        var lista = this.acessaDados.Get${modelNameCamelCase}ById(value, relations);
                        
                        if(lista != null)
                        {
                            var castJson = JsonConvert.SerializeObject(lista);
                            return Json(new { success = true, data = castJson }, JsonRequestBehavior.AllowGet);
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                    }
                }
        
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
            
            /// <summary>
            /// Método responsável por retornar uma lista de ${modelNameCamelCase}
            /// </summary>
            /// <param name="queryObj"></param>
            /// <param name="relations"></param>
            /// <returns>JsonResult</returns>
            [HttpPost]
            public JsonResult GetListDataWithObject()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var queryObj = JsonConvert.DeserializeObject(body);
                            string relations = "";
                            var lista = this.acessaDados.Get${modelNameCamelCase}WithObject(queryObj, relations);
                            
                            if(lista != null)
                            {
                                var castJson = JsonConvert.SerializeObject(lista);
                                return Json(new { success = true, data = castJson }, JsonRequestBehavior.AllowGet);
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                            
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
    
            /// <summary>
            /// Método responsável por salvar os dados de ${modelNameCamelCase}
            /// </summary>
            /// <returns>JsonResult</returns>
            [HttpPost]
            public JsonResult CreateData()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var model = JsonConvert.DeserializeObject<${modelNameCamelCase}ViewModel>(body);
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                            
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.Add${modelNameCamelCase}(model);
                            if(lista > 0)
                                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                
                return Json(new { success = false, message = "Erro ao inserir dados." }, JsonRequestBehavior.AllowGet);
            }
            
            /// <summary>
            /// Método responsável por atualizar os dados de ${modelNameCamelCase}
            /// </summary>
            /// <returns>JsonResult</returns>
            [HttpPut]
            public JsonResult UpdateData()
            {
                using (StreamReader reader = new StreamReader(Request.InputStream))
                {
                    string body = reader.ReadToEnd();
                    if (!string.IsNullOrEmpty(body))
                    {
                        try
                        {
                            var model = JsonConvert.DeserializeObject<${modelNameCamelCase}ViewModel>(body);
                            
                            if (!ModelState.IsValid) 
                                return Json(new { success = false, message = ListErros(ModelState) }, JsonRequestBehavior.AllowGet);
                                
                            var getUser = utils.GetInternalUserAx(UsuarioLogado.Chave);
                            if (getUser != null && getUser.Rows.Count > 0)
                            {
                                model.COD_REG_EMPRG = Convert.ToDecimal(getUser.Rows[0]["COD_IDENT_EMPRE"]);
                                model.COD_REG_USUAR = Convert.ToDecimal(getUser.Rows[0]["COD_REG_EMPRG"]);
                            }
                            
                            var lista = this.acessaDados.Update${modelNameCamelCase}(model);
                            if(lista > 0)
                                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e);
                            return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
    
            /// <summary>
            /// Método responsável por deletar os dados de ${modelNameCamelCase}
            /// </summary>
            /// <param name="${primaryKey.toLowerCase()}"></param>
            /// <returns>JsonResult</returns>
            [HttpDelete]
            public JsonResult DeleteData(string ${primaryKey.toLowerCase()} = "")
            {
                if (!string.IsNullOrEmpty(${primaryKey.toLowerCase()}))
                {
                    try
                    {
                        var value = Convert.ToInt32(${primaryKey.toLowerCase()});
                        var success = this.acessaDados.Delete${modelNameCamelCase}(value);
                        return Json(new { success }, JsonRequestBehavior.AllowGet);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        return Json(new { success = false, message = e.Message }, JsonRequestBehavior.AllowGet);
                    }
                }
        
                return Json(new { success = false }, JsonRequestBehavior.AllowGet);
            }
        
        #endregion

        #region Métodos Herdados
        
            public override List<Acao> AcoesXGT
            {
                get { return new List<Acao>(); }
            }
    
            public override InformacoesXGT InformacoesXGT
            {
                get { return new InformacoesXGT { NomeExecutavel = this.NomeExecutavel }; }
            }
        
        #endregion
    }
}
    `;

}

function generateControllersForAllModels(folderPath) {
    const files = fs.readdirSync(folderPath);
    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const modelName = path.basename(file, '.csv');
            const modelNameCamelCase = camelCaseReName(modelName);
            // get primary key
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const lines = fileData.split('\n');

            lines.shift();

            let columns = [];
            let columnsMoreTypes = [];

            let primaryKey = null;

            lines.forEach(line => {
                if (line.trim() === '') return;
                const fields = splitCsvLine(line);
                if (fields[0] && fields[2] === "PK") {
                    primaryKey = fields[0];
                }
                if (fields[0]) {
                    columns.push(fields[0]);
                    columnsMoreTypes.push([fields[0], fields[1]]);
                }
            });
            const controllerCode = generateControllerForModel(folderPath, modelName, modelNameCamelCase, `${primaryKey || modelName}`, columns);

            const outputPath = path.join(__dirname, 'controllers', `${modelNameCamelCase}Controller.cs`);
            fs.writeFileSync(outputPath, controllerCode, 'utf8');

            console.log(`Controlador ${modelNameCamelCase}Controller.cs criado com sucesso!`);
        }
    });
}


function csvToHtmlForm(csvData, formId) {
    const lines = csvData.split('\n');
    lines.shift();

    let formHtml = `<form id="${formId}" name="${formId}" ng-init="vm.configurarPagina()">\n`;
    formHtml += `    <div class="row">\n`;
    formHtml += `        <br />\n`;
    formHtml += `        <div class="col-sm-12">\n`;

    let inputCounter = 0; // Contador de campos de entrada na linha atual

    lines.forEach(line => {
        if (line === '') return;
        const fields = splitCsvLine(line);

        if (fields[0]) {
            const columnName = fields[0].toLowerCase();
            const databindName = fields[0];
            const type = fields[1].toLowerCase();
            const notNull = fields[2];
            const nameField = fields[3];
            const allowedValues = fields[4];

            let inputHtml = '';
            let cssClass = '';

            // Determina a classe CSS com base no tipo de campo
            if (type.includes("number")) {
                cssClass = 'input-sm numeric-field';
            } else if (type.includes("date")) {
                cssClass = 'input-sm date-field';
            } else if (type.includes("varchar")) {
                cssClass = 'input-sm text-field';
            } else if (type === "boolean") {
                cssClass = 'input-sm boolean-field';
            } else if (type === "password") {
                cssClass = 'input-sm password-field';
            }

            // Abre uma nova linha se o contador atingir 4 campos
            if (inputCounter === 4) {
                formHtml += '        </div>\n';
                formHtml += `        <div class="col-sm-12">\n`;
                inputCounter = 0;
            }

            // Abre o div com a classe CSS adequada
            formHtml += `            <div class="col-sm-3 col-md-2 col-lg-2">\n`;
            formHtml += `                <div class="form-group">\n`;
            formHtml += `                    <label>${nameField}:</label>\n`;

            // Lida com campos permitidos (allowedValues)
            if (allowedValues) {
                const values = allowedValues.split(',');

                if (values.length === 2 && values.includes("P") && values.includes("E")) {
                    inputHtml = `<div class="form-col ${cssClass}" id="${columnName}">\n`;
                    values.forEach(value => {
                        inputHtml += `<input type="radio" class="form-control-radio" id="${columnName}${value}" name="${columnName}" value="${value}" data-bind="checked: ${databindName}" />\n`;
                        inputHtml += `<label for="${columnName}${value}">${value}</label>\n`;
                    });
                    inputHtml += `</div>`;
                } else {
                    inputHtml = `<select class="form-control ${cssClass}" id="${columnName}" name="${columnName}" data-bind="value: ${databindName}">\n`;
                    values.forEach(value => {
                        inputHtml += `<option value="${value.trim()}">${value.trim()}</option>\n`;
                    });
                    inputHtml += `</select>\n`;
                }
            } else {
                if (inputHtml === '') {
                    if (type.includes("number")) {
                        inputHtml = `<input type="number" class="form-control ${cssClass}" id="${columnName}" name="${columnName}"`;
                    } else if (type.includes("date")) {
                        inputHtml = `<input type="datetime-local" class="form-control ${cssClass}" id="${columnName}" name="${columnName}"`;
                    } else if (type.includes("varchar")) {
                        const maxLength = parseInt(type.match(/\((.*?)\)/)[1]);

                        if (maxLength > 100) {
                            inputHtml = `<textarea class="form-control ${cssClass}" id="${columnName}" name="${columnName}" rows="${Math.ceil(maxLength / 250)}"`;
                        } else {
                            inputHtml = `<input type="text" class="form-control ${cssClass}" id="${columnName}" name="${columnName}" maxlength="${maxLength}"`;
                        }
                    } else if (type === "boolean") {
                        inputHtml = `<input type="checkbox" class="form-control ${cssClass}" id="${columnName}" name="${columnName}"`;
                    } else if (type === "password") {
                        inputHtml = `<input type="password" class="form-control ${cssClass}" id="${columnName}" name="${columnName}"`;
                    } else {
                        // Tipo padrão para campos de texto
                        inputHtml = `<input type="text" class="form-control ${cssClass}" id="${columnName}" name="${columnName}"`;
                    }
                }

                if (notNull === 'TRUE' || notNull === 'PK' || notNull === 'YES') {
                    inputHtml += ' required';
                }

                if (inputHtml.includes('textarea')) {
                    inputHtml += ` data-bind="value: ${databindName}"></textarea>`;
                } else {
                    inputHtml += ` data-bind="value: ${databindName}" />`;
                }
            }

            // Adicione o inputHtml ao formHtml
            formHtml += inputHtml;

            // Feche o div da classe form-group
            formHtml += `                </div>\n`;
            formHtml += `            </div>\n`;

            // Incrementa o contador de campos de entrada na linha
            inputCounter++;
        }
    });

    // Feche o div da classe col-sm-12 e a div da classe row
    formHtml += '        </div>\n';
    formHtml += '    </div>\n';

    formHtml += `    <input type="submit" value="Enviar" />\n</form>`;

    return formHtml;
}


function readAllCSVFilesFromFolder(folderPath) {

    const files = fs.readdirSync(folderPath);
    files.forEach(file => {
        const fullPath = path.join(folderPath, file);
        const fileExtension = path.extname(file);

        if (fileExtension === '.csv') {
            const fileData = fs.readFileSync(fullPath, 'utf8');
            const modelName = path.basename(file, '.csv');
            const modelNameCamelCase = camelCaseReName(path.basename(file, '.csv'));

            const viewModelCode = csvToCsharpViewModel(fileData, modelNameCamelCase);
            const edmxModelCode = csvToEdmxModel(fileData, modelName);
            const csvToCode = csvToHtmlForm(fileData, modelNameCamelCase);

            // Escreve o modelo em um arquivo na pasta 'ViewModel'
            const outputPath = path.join(__dirname, 'viewModel', `${modelNameCamelCase}ViewModel.cs`);
            fs.writeFileSync(outputPath, viewModelCode, 'utf8');
            console.log(`ViewModelo ${modelNameCamelCase}ViewModel.cs criado com sucesso!`);

            // Escreve o modelo em um arquivo na pasta 'edmxModel'
            const outputPath2 = path.join(__dirname, 'edmxModel', `${modelName}.cs`);
            fs.writeFileSync(outputPath2, edmxModelCode, 'utf8');
            console.log(`EdmxModelo ${modelName}.cs criado com sucesso!`);


            // Escreve o modelo em um arquivo na pasta 'edmxModel'
            const outputPath3 = path.join(__dirname, 'html', `${modelName}.html`);
            fs.writeFileSync(outputPath3, csvToCode, 'utf8');
            console.log(`EdmxModelo ${modelName}.cs criado com sucesso!`);


        }
    });

    injectForeignKeyReferences(folderPath);
    generateDalClassesForAllModels(folderPath);
    generatePostmanCollectionForAllModels(folderPath);
    generateControllersForAllModels(folderPath);

}

readAllCSVFilesFromFolder('./csv-converter/');
