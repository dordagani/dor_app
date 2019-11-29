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
                sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.unitTest ."
            }
        }
        stage ('Deploy') {
            steps {
                containerID = sh(returnStdout: true, script: 'docker run -d dor_app:test-B${BUILD_NUMBER}').trim()
                echo "Container ID is ==> ${containerID}"
                }
            }   
        }   
    }
