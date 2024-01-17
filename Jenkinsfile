pipeline {
    agent any

    environment {
      DOCKERHUB_CREDENTIALS = credentials('docker')
    }

    stages {
      stage('Development Environment testing') {
        steps {
          script {
              sh "kubectl apply -f development.yml"
              sh "curl localhost:8082"
          }
        }
      }
    }
}