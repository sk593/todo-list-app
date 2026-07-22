extension radius

param environment string

@secure()
param password string

@description('The container image tag to build and push (e.g. a commit SHA). Registry and image name come from the recipe pack and resource name.')
param image string = 'latest'

@description('Username for the OCI registry that the containerImages recipe pushes built images to (e.g. the GitHub actor for ghcr.io).')
param registryUsername string

@description('Password/token for the OCI registry that the containerImages recipe pushes built images to (e.g. a GitHub token with write:packages for ghcr.io).')
@secure()
param registryPassword string

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

// Registry credentials for the containerImages recipe. The bicep containerImages
// recipe reads a Kubernetes Secret (named by the recipe pack's registrySecretName,
// 'ghcr-registry-creds') with `username`/`password` keys from the recipe runtime
// namespace on the TARGET cluster (the Radius bicep driver resolves the registry
// Secret via RADIUS_TARGET_KUBECONFIG, not the control-plane cluster). Declaring
// the credentials as a Radius.Security/secrets resource here materializes that
// Secret in the application's namespace on the target cluster, co-located with the
// build. The registry itself (where images are pushed) is an operator concern set
// on the recipe pack's `registry` parameter and cannot be set on the resource.
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
  // The build reads the registry Secret at recipe execution time, so the Secret
  // must already exist on the target cluster before the image is built and pushed.
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
