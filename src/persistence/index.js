function getConnectionProperty(connectionName, propertyName) {
    const properties = process.env[`CONNECTION_${connectionName}_PROPERTIES`];

    if (properties) {
        try {
            const parsedProperties = JSON.parse(properties);
            const propertyKey = Object.keys(parsedProperties).find(
                (key) => key.toLowerCase() === propertyName.toLowerCase(),
            );
            const value = propertyKey ? parsedProperties[propertyKey] : undefined;

            if (value !== undefined && value !== null) {
                return String(value);
            }
        } catch (err) {
            // Fall through to the individual connection variables fallback below.
        }
    }

    return process.env[`CONNECTION_${connectionName}_${propertyName}`];
}

const mysqlHost = process.env.MYSQL_HOST || getConnectionProperty('MYSQLDB', 'HOST');

if (mysqlHost) {
    process.env.MYSQL_HOST = mysqlHost;
    const mysqlUser = process.env.MYSQL_USER || getConnectionProperty('MYSQLDB', 'USERNAME');
    const mysqlPassword = process.env.MYSQL_PASSWORD || getConnectionProperty('MYSQLDB', 'PASSWORD');
    const mysqlDatabase = process.env.MYSQL_DB || getConnectionProperty('MYSQLDB', 'DATABASE');

    if (mysqlUser) process.env.MYSQL_USER = mysqlUser;
    if (mysqlPassword) process.env.MYSQL_PASSWORD = mysqlPassword;
    if (mysqlDatabase) process.env.MYSQL_DB = mysqlDatabase;

    module.exports = require('./mysql');
} else {
    module.exports = require('./sqlite');
}
