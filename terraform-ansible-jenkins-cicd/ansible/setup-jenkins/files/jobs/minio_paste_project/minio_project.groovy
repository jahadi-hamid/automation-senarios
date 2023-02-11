pipelineJob('minio_paste') {
  definition {
    cps {
      script("""
        pipeline {
          agent any
          stages {
            stage('Clone repository') {
              steps {
                git url: 'https://github.com/jahadi-hamid/automation-senarios.git'
              }
            }
            stage('Build Docker image') {
              steps {
                sh 'cd terraform-ansible-jenkins-cicd/minio-upload/ && docker-compose -f docker-compose.yml build --no-cache'
              }
            }
            stage('Run with Docker Compose') {
              steps {
                sh 'cd terraform-ansible-jenkins-cicd/minio-upload/ && docker-compose up -d'
              }
            }
          }
        }
      """)
    }
  }
}