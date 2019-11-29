pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                 checkout scm
            }
        }
        stage('Unit Test') {
            steps {
                sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.Integration ."
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
