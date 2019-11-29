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
        stage 'Deploy'
                echo 'Deploying....'
                containerID = sh (script: "docker run -d dor_app:test-B${BUILD_NUMBER}", returnStdout: true).trim()
                echo "Container ID is ==> ${containerID}"
                sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                sh "docker stop ${containerID}"
                sh "docker rm ${containerID}"
                step([$class: 'MSTestPublisher', failOnError: false, testResultsFile: 'test_report.xml'])
    }
}
