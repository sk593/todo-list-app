const MYSQL_ENV_VARS = [
    'MYSQL_HOST',
    'MYSQL_USER',
    'MYSQL_PASSWORD',
    'MYSQL_DB',
    'CONNECTION_MYSQLDB_PROPERTIES',
    'CONNECTION_MYSQLDB_HOST',
    'CONNECTION_MYSQLDB_USERNAME',
    'CONNECTION_MYSQLDB_PASSWORD',
    'CONNECTION_MYSQLDB_DATABASE',
];

const mysqlPersistence = { kind: 'mysql' };
const sqlitePersistence = { kind: 'sqlite' };

beforeEach(() => {
    jest.resetModules();

    for (const envVar of MYSQL_ENV_VARS) {
        delete process.env[envVar];
    }
});

test('it uses mysql persistence from Radius connection properties', () => {
    process.env.CONNECTION_MYSQLDB_PROPERTIES = JSON.stringify({
        host: 'mysql',
        username: 'todo_list_app_user',
        password: 'secret',
        database: 'todos',
    });

    jest.doMock('../../src/persistence/mysql', () => mysqlPersistence);
    jest.doMock('../../src/persistence/sqlite', () => sqlitePersistence);

    const persistence = require('../../src/persistence');

    expect(persistence).toBe(mysqlPersistence);
    expect(process.env.MYSQL_HOST).toBe('mysql');
    expect(process.env.MYSQL_USER).toBe('todo_list_app_user');
    expect(process.env.MYSQL_PASSWORD).toBe('secret');
    expect(process.env.MYSQL_DB).toBe('todos');
});

test('it uses mysql persistence from Radius individual connection env vars', () => {
    process.env.CONNECTION_MYSQLDB_HOST = 'mysql';
    process.env.CONNECTION_MYSQLDB_USERNAME = 'todo_list_app_user';
    process.env.CONNECTION_MYSQLDB_PASSWORD = 'secret';
    process.env.CONNECTION_MYSQLDB_DATABASE = 'todos';

    jest.doMock('../../src/persistence/mysql', () => mysqlPersistence);
    jest.doMock('../../src/persistence/sqlite', () => sqlitePersistence);

    const persistence = require('../../src/persistence');

    expect(persistence).toBe(mysqlPersistence);
    expect(process.env.MYSQL_HOST).toBe('mysql');
    expect(process.env.MYSQL_USER).toBe('todo_list_app_user');
    expect(process.env.MYSQL_PASSWORD).toBe('secret');
    expect(process.env.MYSQL_DB).toBe('todos');
});

test('it uses sqlite persistence when no mysql connection metadata exists', () => {
    jest.doMock('../../src/persistence/mysql', () => mysqlPersistence);
    jest.doMock('../../src/persistence/sqlite', () => sqlitePersistence);

    const persistence = require('../../src/persistence');

    expect(persistence).toBe(sqlitePersistence);
});
