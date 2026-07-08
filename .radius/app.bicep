extension radius

param environment string

@secure()
param password string

@description('The container image tag to build and push (e.g. a commit SHA). Registry and image name come from the recipe pack and resource name.')
param image string = 'latest'

resource todoApp 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'todo-list-app'
  properties: {
    environment: environment
  }
}

resource database 'Radius.Data/mySqlDatabases@2025-08-01-preview' = {
  name: 'mysqldb-e8b3ed'
  properties: {
    environment: environment
    application: todoApp.id
    database: 'todos'
    version: '8.0'
    username: 'todo_list_app_user'
    password: password
  }
}

// Registry credentials for the containerImages recipe are provisioned at the
// platform level: the deploy workflow creates a Kubernetes Secret named
// 'ghcr-registry-creds' on the control-plane cluster (where the recipe's in-pod
// BuildKit runs) from the default GitHub token, and passes its name to the
// recipe pack via registrySecretName. The application therefore carries no
// registry credentials of its own.
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
