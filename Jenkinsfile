def customImage
pipeline {
    agent any

    stages {
        stage('Git') {
            steps {
                echo '> Checking out the Git version control ...'
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo '> Building the test docker images ...' 
                    customImage = docker.build("dordagani/flask_app:B${BUILD_NUMBER}")

                    // docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-hub-credentials') {
                    //   customImage.push()
                    // }
                  }
                // sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.unitTest ."
            }
        }
        stage ('Unit Test') {
            steps {
                echo '> Doing Unit Test ...'
                script {
                  containerID = sh(returnStdout: true, script: 'docker run -d \
                  dordagani/flask_app:B${BUILD_NUMBER}').trim()
//                   # CMD py.test --junitxml=/data/test_report.xml \
// #             --cov-report xml:/data/coverage.xml
                  echo "Container ID is ==> ${containerID}"
                  sh "docker stop ${containerID}"
                  sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                  sh "docker rm ${containerID}"
                  step([$class: 'JUnitResultArchiver', testResults: 'test_report.xml'])
                }
            }
        }
        stage ('Push to Docker Hun') {
            steps {
                script {
                    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                        echo '> Pushing to Docker Hub ...'
                        docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-hub-credentials') {
                          customImage.push()
                        }
                    }
                }
            }   
        }
    }
/*     post {
        always {
            junit 'test_report.xml'
        }
    } */  
}
