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
                script {
                  def customImage = docker.build("dor_app:test-B${BUILD_NUMBER}")
                  }
                // sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.unitTest ."
            }
        }
        stage ('Deploy') {
            steps {
                echo "Deploy....."
                // sh "docker run -d --name dor_app_test dor_app:test-B${BUILD_NUMBER}"
                // sh "docker cp dor_app_test:/data/test_report.xml test_report.xml"
                // sh "docker stop dor_app_test"
                // sh "docker rm dor_app_test"
                // step([$class: 'MSTestPublisher', failOnError: false, testResultsFile: 'test_report.xml'])
                script {
                  containerID = sh(returnStdout: true, script: 'docker run -d dor_app:test-B${BUILD_NUMBER}').trim()
                  echo "Container ID is ==> ${containerID}"
                  sh "docker stop ${containerID}"
                  sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                  sh "docker rm ${containerID}"
                  step([$class: 'JUnitResultArchiver', testResults: 'test_report.xml'])
                //   if (currentBuild.result == 'UNSTABLE')
                //      currentBuild.result = 'FAILURE'
                //   step([$class: 'MSTestPublisher', failOnError: false, testResultsFile: 'test_report.xml'])
                }
            }
        }
        stage ('After test') {
            steps {
                script {
                    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                        echo "After test..."
                    }
                }
            }   
        }
        stage ( 'After After test' ) {
            steps {
                echo "After After test!!!"
            }
        }
    }
    post {
        always {
            junit 'test_report.xml'
        }
    }  
}
