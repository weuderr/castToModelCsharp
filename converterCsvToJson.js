const fs = require('fs');
const path = require('path');

const csvFolderPath = './docs/csv-SBeleza';
const jsonFolderPath = './docs/SBeleza';

// Função para remover aspas extras e espaços em branco desnecessários
const cleanValue = (value) => {
    return value.replace(/^"|"$/g, '').trim();
};

// Função para converter uma linha CSV em um objeto JSON
const csvLineToJson = (headers, line) => {
    const values = line.split(',').map(cleanValue); // Limpa cada valor
    return headers.reduce((obj, header, index) => {
        const cleanHeader = cleanValue(header);
        // Adaptação para o novo formato do JSON
        if (values[index] !== '') { // Verifica se o valor não é vazio
            const type = values[1]?.split('(')[0];
            const regex = /\(([^)]+)\)/;
            const size = values[1]?.match(regex)?.[1] || null;
            obj['Atributo'] = values[0];
            obj['Tipo'] = type === 'varchar' ? 'String' : type === 'date' ? 'Date' : type === 'bit' ? 'bool' : type === 'datetime' ? 'DateTime' : type === 'text' ? 'Text' : type === 'tinyint' ? 'TinyInt' : type === 'bigint' ? 'long' : type === 'smallint' ? 'SmallInt' : type === 'char' ? 'Char' : type === 'float' ? 'Float' : type === 'double' ? 'Double' : type === 'real' ? 'Real' : type === 'numeric' ? 'Numeric' : type === 'money' ? 'Money' : type === 'smallmoney' ? 'SmallMoney' : type === 'uniqueidentifier' ? 'UniqueIdentifier' : type === 'xml' ? 'Xml' : type === 'binary' ? 'Binary' : type === 'varbinary' ? 'VarBinary' : type === 'image' ? 'Image' : type === 'timestamp' ? 'Timestamp' : type === 'rowversion' ? 'RowVersion' : type === 'time' ? 'Time' : type === 'datetime2' ? 'DateTime2' : type === 'datetimeoffset' ? 'DateTimeOffset' : type === 'geography' ? 'Geography' : type === 'geometry' ? 'Geometry' : type === 'hierarchyid' ? 'HierarchyId' : type === 'sql_variant' ? 'SqlVariant' : type === 'table' ? 'Table' : type === 'cursor' ? 'Cursor' : type === 'timestamp' ? 'Timestamp' : type === 'sql_variant' ? 'SqlVariant' : type === 'table' ? 'Table' : type === 'cursor' ? 'Cursor' : type === 'uniqueidentifier' ? 'UniqueIdentifier' : type === 'xml' ? 'Xml' : type === 'geography' ? 'Geography' : type === 'geometry' ? 'Geometry' : type === 'hierarchyid' ? 'HierarchyId' : type === 'sql_variant' ? 'SqlVariant' : type === 'table' ? 'Table' : type === 'cursor' ? 'Cursor' : type === 'timestamp' ? 'Timestamp' : type === 'sql_variant' ? 'SqlVariant' : type === 'table' ? 'Table' : type === 'cursor' ? 'Cursor' : type === 'uniqueidentifier' ? 'UniqueIdentifier' : type === 'xml' ? 'Xml' : type ;
            if (size) {
                obj['Tamanho'] = parseInt(size, 10);
            }
            obj['Obrigatoriedade'] = values[2];
            obj['Descricao'] = values[3];
        }
        return obj;
    }, {});
};

fs.readdir(csvFolderPath, (err, files) => {
    if (err) {
        console.error('Erro ao ler a pasta:', err);
        return;
    }

    files.forEach((file) => {
        if (path.extname(file).toLowerCase() === '.csv') {
            const csvFilePath = path.join(csvFolderPath, file);
            fs.readFile(csvFilePath, 'utf8', (err, data) => {
                if (err) {
                    console.error('Erro ao ler o arquivo:', err);
                    return;
                }

                const lines = data.split('\n').filter(line => line.trim() !== ''); // Ignora linhas vazias
                const headers = lines.shift().split(',').map(cleanValue); // Limpa os cabeçalhos
                const json = lines.map(line => csvLineToJson(headers, line));

                if (!fs.existsSync(path.join(__dirname, jsonFolderPath))) {
                    fs.mkdirSync(path.join(__dirname, jsonFolderPath));
                }

                const jsonFilePath = path.join(jsonFolderPath, path.basename(file, '.csv') + '.json');
                fs.writeFile(jsonFilePath, JSON.stringify(json, null, 2), 'utf8', (err) => {
                    if (err) {
                        console.error('Erro ao salvar o arquivo JSON:', err);
                        return;
                    }
                    console.log('Arquivo JSON salvo com sucesso:', jsonFilePath);
                });
            });
        }
    });
});
