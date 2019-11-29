pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                 sh "ls -la ${pwd()}"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}