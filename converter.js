const fs = require('fs');
const path = require('path');

function extractTablesFromSQL(sqlContent) {
    // Remove comentários de bloco e de linha única
    sqlContent = sqlContent.replace(/\/\*[\s\S]*?\*\//g, '').replace(/--.*$/gm, '');

    const tableRegEx = /CREATE TABLE (\w+(?:\.\w+)?)\s*\(([\s\S]+?)\)\s*(?=;)/gi;
    let match;
    const tables = [];

    while ((match = tableRegEx.exec(sqlContent)) !== null) {
        const tableName = match[1]?.split('.').pop();
        const columnsContent = match[2];

        // Pré-processa constraints para PK e FK
        const constraints = {};
        const pkRegEx = /CONSTRAINT \w+ PRIMARY KEY \((\w+)\)/gi;
        const fkRegEx = /CONSTRAINT \w+ FOREIGN KEY \((\w+)\) REFERENCES ACESITA.(\w+)/gi; //TODO CORRIGIR PAGA ACESITA QUE PEGUE O NOME DO SCHEMA

        let pkMatch;
        while ((pkMatch = pkRegEx.exec(columnsContent)) !== null) {
            constraints[pkMatch[1]] = 'PK';
        }

        let fkMatch;
        while ((fkMatch = fkRegEx.exec(columnsContent)) !== null) {
            constraints[fkMatch[1]] = `FK:${fkMatch[2]}`;
        }

        const columnRegEx = /(\w+)\s+([\w]+(?:\(\d+(?:,\d+)?\))?)( not null)?/gi;
        let colMatch;
        const columns = [];

        while ((colMatch = columnRegEx.exec(columnsContent)) !== null) {
            const columnName = colMatch[1];

            // Ignora linhas com palavras-chave específicas
            if (["PRIMARY", "CONSTRAINT", "IS", "FOREIGN", "REFERENCES"].includes(columnName)) {
                continue;
            }

            const type = colMatch[2];
            let notNull = constraints[columnName] || (colMatch[3] ? 'TRUE' : 'FALSE');

            columns.push({
                columnName: columnName,
                type: type,
                notNull: notNull
            });
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
        fs.writeFileSync(path.join('./csv-converter/', `${table.tableName}.csv`), csvContent);
    });
}

sqlToCSVFiles('./sql/inputFile.sql');
