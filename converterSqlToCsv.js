const fs = require('fs');
const path = require('path');
const {getTypeForValidate} = require("./lib/Utils");

function extractTablesFromSQL(sqlContent) {
    // Remove comentários de bloco e de linha única
    sqlContent = sqlContent.replace(/\/\*[\s\S]*?\*\//g, '').replace(/--.*$/gm, '');

    const tableRegEx = /CREATE\s+TABLE\s+"?(\w+(?:\.\w+)?)\s*"?\s*\(([\s\S]+?)\)\s*(?=;)/gi;
    let match;
    const tables = [];

    while ((match = tableRegEx.exec(sqlContent)) !== null) {
        const tableName = match[1]?.split('.').pop();
        const columnsContent = match[2];

        // Pré-processa constraints para PK e FK
        const constraints = {};
        const pkRegEx = /CONSTRAINT\s+"?(\w+)"?\s+PRIMARY\s+KEY\s+\(?"?(\w+)"?\)?/gi;
        const fkRegEx = /(\w+)\s+([\w]+(?:\(\d+\))?)\s+(not\s+null\s+)?CONSTRAINT\s+\w+(\n)?\s+REFERENCES\s+"?(?:(\w+\.)?(\w+))"?\s*,?/gi;

        let pkMatch;
        while ((pkMatch = pkRegEx.exec(columnsContent)) !== null) {
            constraints[pkMatch[1]] = 'PK';
        }

        let fkMatch;
        while ((fkMatch = fkRegEx.exec(columnsContent)) !== null) {
            if(fkMatch[1].includes('Not')) {
                console.log('fkMatch', fkMatch);
            }
            constraints[fkMatch[1]] = `FK:${fkMatch[6]}`;
        }

        // const columnRegEx = /(\w+)\s+([\w]+(?:\(\d+(?:,\d+)?\))?)( not null)?/gi;
        const columnRegEx = /(\w+)\s+(\w+(?:\(\d+(?:,\d+)?\))?)( not null)?[^,]*/gi;
        // const fkRegEx = /CONSTRAINT\s+"?(\w+)"?\s+FOREIGN\s+KEY\s+\(?"?(\w+)"?\)\s+REFERENCES\s+"?(\w+(?:\.\w+)*)"?\s*\("?(\w+)"?\)/gi;
        let colMatch;
        const columns = [];

        while ((colMatch = columnRegEx.exec(columnsContent)) !== null) {
            const columnName = colMatch[1];

            // Ignora linhas com palavras-chave específicas
            if (["PRIMARY", "CONSTRAINT", "IS", "FOREIGN", "REFERENCES"].includes(columnName.toUpperCase())) {
                continue;
            }

            if(columnName.toUpperCase() === 'ID') {
                constraints[columnName] = 'PK';
            }

            const type = colMatch[2]?.replace("nvarchar", "string");
            let notNull = constraints[columnName] || (colMatch[3] ? 'TRUE' : 'FALSE');


            if(colMatch[1].includes('not') && colMatch[2].includes('null')) {
                console.log('fkMatch', fkMatch);
            } else {
                columns.push({
                    columnName: columnName,
                    type: type,
                    notNull: notNull
                });
            }
        }

        tables.push({
            tableName: tableName,
            columns: columns
        });
    }

    return tables;
}

function tableToCSV(table) {
    let csvContent = "Collumn Name,Type,Not Null,Name Field,Allow values\n";

    table.columns.forEach(column => {
        csvContent += `"${column.columnName}","${column.type}",${column.notNull},,\n`;
    });

    return csvContent;
}

function sqlToCSVFiles(sqlFilePath) {
    const sqlContent = fs.readFileSync(sqlFilePath, 'utf8');
    const tables = extractTablesFromSQL(sqlContent);

    tables.forEach(table => {
        const csvContent = tableToCSV(table);
        fs.writeFileSync(path.join('./docs/',names[1], `/${table.tableName}.csv`), csvContent);

        console.log('Arquivo criado: ', table.tableName);
    });
}

// const names ['net5', 'dotnetCast'];
const names = ['net8', 'csv-SBeleza'];

sqlToCSVFiles('./input-sql/'+names[0]+'.sql');
