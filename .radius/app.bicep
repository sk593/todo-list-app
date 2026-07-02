extension radius

param environment string

@secure()
param password string

@description('The container image tag to build and push (e.g. a commit SHA). Registry and image name come from the recipe pack and resource name.')
param image string = 'latest'

@description('Registry username for the containerImages image push (supplied by the deploy workflow).')
param registryUsername string = ''
@secure()
@description('Registry password/token for the containerImages image push (supplied by the deploy workflow).')
param registryPassword string = ''

resource todoApp 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
  }
}

resource database 'Radius.Data/mySqlDatabases@2025-08-01-preview' = {
  name: 'mysqldb'
  properties: {
    environment: environment
    application: todoApp.id
    database: 'todos'
    version: '8.0'
    secretName: dbSecret.name
  }
}

resource dbSecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'dbsecret'
  properties: {
    environment: environment
    application: todoApp.id
    data: {
      USERNAME: {
        value: 'todo_list_app_user'
      }
      PASSWORD: {
        value: password
      }
    }
  }
}

// Registry credentials for the containerImages recipe to authenticate its image
// push. Application-scoped so the secrets recipe materializes a Kubernetes Secret
// named 'ghcr-registry-creds' into this app's namespace -- the same namespace the
// containerImages recipe reads from (context.runtime.kubernetes.namespace). The
// name MUST match the recipe pack's registrySecretName set by the deploy workflow.
resource registryCreds 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'ghcr-registry-creds'
  properties: {
    environment: environment
    application: todoApp.id
    data: {
      username: {
        value: registryUsername
      }
      password: {
        value: registryPassword
      }
    }
  }
  // Serialize secret provisioning: deploying multiple Radius.Security/secrets
  // in parallel races on a shared backend and fails with a concurrency conflict,
  // so order this secret after dbSecret to force sequential deployment.
  dependsOn: [
    dbSecret
  ]
}

resource demoImage 'Radius.Compute/containerImages@2025-08-01-preview' = {
  name: 'demo-image'
  properties: {
    environment: environment
    application: todoApp.id
    tag: image
    build: {
      source: 'git::https://github.com/sk593/todo-list-app.git'
    }
  }
  dependsOn: [
    registryCreds
  ]
}

resource todoContainer 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'todo-list-frontend'
  properties: {
    environment: environment
    application: todoApp.id
    containers: {
      todo: {
        image: demoImage.properties.imageReference
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
    connections: {
      mysqldb: {
        source: database.id
      }
      demoContainerImage: {
        source: demoImage.id
      }
    }
  }
}
