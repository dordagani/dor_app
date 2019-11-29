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
                def customImage = docker.build("dor_app:test-B")
                // sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.unitTest ."
            }
        }
        stage ('Deploy') {
            steps {
                echo "Deploy....."
                // containerID = sh(returnStdout: true, script: 'docker run -d dor_app:test-B${BUILD_NUMBER}').trim()
                // echo "Container ID is ==> ${containerID}"
                // sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                // sh "docker stop ${containerID}"
                // sh "docker rm ${containerID}"
                // step([$class: 'MSTestPublisher', failOnError: false, testResultsFile: 'test_report.xml'])
                }
            }   
        }   
    }
