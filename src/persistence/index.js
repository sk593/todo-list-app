function getConnectionProperty(connectionName, propertyName) {
    const properties = process.env[`CONNECTION_${connectionName}_PROPERTIES`];

    if (properties) {
        try {
            const parsedProperties = JSON.parse(properties);
            const value = parsedProperties[propertyName.toLowerCase()];

            if (value !== undefined && value !== null) {
                return `${value}`;
            }
        } catch (err) {
            return process.env[`CONNECTION_${connectionName}_${propertyName}`] || '';
        }
    }

    return process.env[`CONNECTION_${connectionName}_${propertyName}`] || '';
}

const mysqlHost = process.env.MYSQL_HOST || getConnectionProperty('MYSQLDB', 'HOST');

if (mysqlHost) {
    process.env.MYSQL_HOST = mysqlHost;
    process.env.MYSQL_USER = process.env.MYSQL_USER || getConnectionProperty('MYSQLDB', 'USERNAME');
    process.env.MYSQL_PASSWORD = process.env.MYSQL_PASSWORD || getConnectionProperty('MYSQLDB', 'PASSWORD');
    process.env.MYSQL_DB = process.env.MYSQL_DB || getConnectionProperty('MYSQLDB', 'DATABASE');

    module.exports = require('./mysql');
} else {
    module.exports = require('./sqlite');
}
