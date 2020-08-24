pipeline {
  agent any

  environment {
  }

  parameters {
    string(name: 'VERSION', defaultValue: env.BUILD_NUMBER, description: 'The version of chaincode')
    string(name: 'SEQUENCE', defaultValue: env.BUILD_NUMBER, description: 'The sequence of chaincode')
  }

  stages {

    stage('Compiling Chaincode') {
      steps {
          sh "make deployCC USE_DOMAIN=1 VERSION=${params.VERSION} SEQUENCE=${params.SEQUENCE}"
      }
    }
  }
}
