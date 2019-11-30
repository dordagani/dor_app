pipeline {
    agent any

    stages {
        stage('Git') {
            steps {
                echo '> Checking out the Git version control ...'
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    echo '> Building the test docker images ...' 
                    def customImage = docker.build("dor_app:-B${BUILD_NUMBER}")

                    customImage.push()
                  }
                // sh "docker build -t dor_app:test-B${BUILD_NUMBER} -f Dockerfile.unitTest ."
            }
        }
        stage ('Unit Test test') {
            steps {
                echo "Do Unit Test....."
                script {
                  containerID = sh(returnStdout: true, script: 'docker run -d dor_app:test-B${BUILD_NUMBER}').trim()
                  echo "Container ID is ==> ${containerID}"
                  sh "docker stop ${containerID}"
                  sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                  sh "docker rm ${containerID}"
                  step([$class: 'JUnitResultArchiver', testResults: 'test_report.xml'])
                }
            }
        }
        stage ('only if unit-test passed') {
            steps {
                script {
                    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                        echo "After test..."
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
