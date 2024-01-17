pipeline {
    agent any

    stages {
      stage('Development Environment testing') {
        steps {
          script {
              sh "./kill-dev.sh"
              sh "kubectl apply -f development.yml"
              sh "curl localhost:8082"
          }
        }
      }
    }
}