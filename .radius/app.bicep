extension radius

@description('Radius environment to deploy the application into.')
param environment string

@description('Administrator password for the MySQL database the application connects to.')
@secure()
param mysqlPassword string

@description('Username for the OCI registry the containerImages recipe pushes to (the GitHub actor for ghcr.io).')
@secure()
param registryUsername string

@description('Password/token for the OCI registry the containerImages recipe pushes to (a GitHub token with write:packages for ghcr.io).')
@secure()
param registryPassword string

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
  }
}

resource mysqlDb 'Radius.Data/mySqlDatabases@2025-08-01-preview' = {
  name: 'todo-list-app-mysql'
  properties: {
    environment: environment
    application: app.id
    database: 'todos'
    version: '8.0'
    username: 'myadmin'
    password: mysqlPassword
    codeReference: 'src/persistence/mysql.js#L24'
  }
}

resource mysqlClientCredentials 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'mysql-client-credentials'
  properties: {
    environment: environment
    application: app.id
    data: {
      password: {
        value: mysqlPassword
      }
    }
    codeReference: 'src/persistence/mysql.js#L10'
  }
}

// Do not change this Secret's name value from 'radius-ghcr-registry-creds'.
// The containerImages recipe looks up registry credentials by that fixed name.
resource registryCreds 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'radius-ghcr-registry-creds'
  properties: {
    environment: environment
    application: app.id
    data: {
      username: {
        value: registryUsername
      }
      password: {
        value: registryPassword
      }
    }
    codeReference: 'Dockerfile'
  }
}

resource todoImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'todo-list-app-image'
  properties: {
    environment: environment
    application: app.id
    tag: 'c9f5029'
    build: {
      source: 'git::https://github.com/sk593/todo-list-app.git?ref=c9f50297cf7ff038dd430f4bf3bf032c3329b757'
      dockerfile: 'Dockerfile'
      platforms: [
        'linux/amd64'
      ]
    }
    codeReference: 'Dockerfile'
  }
  dependsOn: [
    registryCreds
  ]
}

resource todoContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
    application: app.id
    containers: {
      todo: {
        image: todoImage.properties.imageReference
        ports: {
          web: {
            containerPort: 3000
          }
        }
        env: {
          MYSQL_HOST: {
            value: mysqlDb.properties.host
          }
          MYSQL_USER: {
            value: 'myadmin'
          }
          MYSQL_DB: {
            value: 'todos'
          }
          MYSQL_PASSWORD: {
            valueFrom: {
              secretKeyRef: {
                secretName: mysqlClientCredentials.name
                key: 'password'
              }
            }
          }
        }
      }
    }
    codeReference: 'src/index.js#L17'
  }
}
