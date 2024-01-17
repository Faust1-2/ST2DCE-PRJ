pipeline {
    agent any

    stages {
      stage('Development Environment testing') {
        steps {
          script {
              sh "kubectl delete service -n=development devops-service"
              sh "kubectl delete deployment -n=development devops"
              sh "kubectl apply -f development.yml"
              sh "curl localhost:8082"
          }
        }
      }
    }
}