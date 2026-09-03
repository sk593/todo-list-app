extension radius

param environment string

@secure()
param mysqlPassword string

@description('Password/token for the OCI registry the containerImages recipe pushes to (a GitHub token with write:packages for ghcr.io).')
@secure()
param registryPassword string

@description('Username for the OCI registry the containerImages recipe pushes to (the GitHub actor for ghcr.io).')
@secure()
param registryUsername string

resource todoApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
  }
}

resource mysqlDb 'Radius.Data/mySqlDatabases@2025-08-01-preview' = {
  name: 'mysql'
  properties: {
    application: todoApp.id
    codeReference: 'src/persistence/mysql.js#L31'
    database: 'todos'
    environment: environment
    password: mysqlPassword
    username: 'myadmin'
    version: '8.0'
  }
}

resource mysqlClientCredentials 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'mysql-client-credentials'
  properties: {
    application: todoApp.id
    codeReference: 'src/persistence/mysql.js#L10'
    data: {
      password: {
        value: mysqlPassword
      }
    }
    environment: environment
  }
}

resource registryCreds 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'radius-ghcr-registry-creds'
  properties: {
    application: todoApp.id
    codeReference: '.radius/app.bicep#L50'
    data: {
      password: {
        value: registryPassword
      }
      username: {
        value: registryUsername
      }
    }
    environment: environment
  }
}

resource todoImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'todo-list-app-image'
  properties: {
    application: todoApp.id
    build: {
      platforms: [
        'linux/amd64'
      ]
      source: 'git::https://github.com/sk593/todo-list-app.git?ref=072165f9bf10d42e8d860b5a3af618be3c234ce4'
    }
    codeReference: 'Dockerfile#L3'
    environment: environment
    tag: '072165f9bf10d42e8d860b5a3af618be3c234ce4'
  }
  dependsOn: [
    registryCreds
  ]
}

resource todoContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'todo-list-app'
  properties: {
    application: todoApp.id
    codeReference: 'src/index.js#L18'
    containers: {
      todo: {
        env: {
          MYSQL_DB: {
            value: 'todos'
          }
          MYSQL_HOST: {
            value: mysqlDb.properties.host
          }
          MYSQL_PASSWORD: {
            valueFrom: {
              secretKeyRef: {
                key: 'password'
                secretName: mysqlClientCredentials.name
              }
            }
          }
          MYSQL_SSL: {
            value: 'true'
          }
          MYSQL_USER: {
            value: 'myadmin'
          }
        }
        image: todoImage.properties.imageReference
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
    environment: environment
  }
}
