pipeline {
  agent any

  environment {
    JAVA_SRC_PATH="chaincode/fabcar/java"
    CC_SRC_PATH="chaincode/fabcar/java/build/install/fabcar"
    CC_RUNTIME_LANGUAGE="java"
  }

  parameters {
    string(name: 'VERSION', defaultValue: '1', description: 'The version of chaincode')
  }

  stages {

    stage('Compiling Chaincode') {
      steps {
        dir(env.JAVA_SRC_PATH) {
          sh './gradlew installDist'
        }
      }
    }

    stage('Package Chaincode') {
      steps {
        sh '''
        peer lifecycle chaincode package fabcar.tar.gz \
          --path ${CC_SRC_PATH} \
          --lang ${CC_RUNTIME_LANGUAGE} \
          --label fabcar_${VERSION}
        '''
      }
    }

    stage('Commit Chaincode') {
        steps {
          sh '''
          peer lifecycle chaincode commit \
            -o localhost:7050 \
            --ordererTLSHostnameOverride orderer.example.com \
            --tls --cafile $ORDERER_CA \
            --channelID $CHANNEL_NAME \
            --name fabcar $PEER_CONN_PARMS \
            --version ${VERSION} \
            --sequence ${VERSION} \
            --init-required
          '''
        }
    }
  }
}
