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
                    echo '> Building the docker image ...' 
                    customImage = docker.build("dordagani/flask_app-image:B${BUILD_NUMBER}")
                  }
            }
        }
        stage ('Unit Test') {
            steps {
                echo '> Doing Unit Test ...'
                script {
                  containerID = sh(returnStdout: true, script: 'docker run -d \
                  dordagani/flask_app-image:B${BUILD_NUMBER} py.test --junitxml=/data/test_report.xml \
                                                               --cov-report xml:/data/coverage.xml \
                  ').trim()
                  echo "Container ID is ==> ${containerID}"
                  sh "docker stop ${containerID}"
                  sh "docker cp ${containerID}:/data/test_report.xml test_report.xml"
                  sh "docker rm ${containerID}"
                  step([$class: 'JUnitResultArchiver', testResults: 'test_report.xml'])
                }
            }
        }
        stage ('Push to Docker Hub') {
            steps {
                script {
                    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                        echo '> Pushing to Docker Hub ...'
                        docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-hub-credentials') {
                          customImage.push()
                          customImage.push('latest')
                          // Delete the container image!!!!
                        }
                    }
                }
            }   
        }

        stage ('Deploy') {
            steps {
                echo '> Deploying the docker container ...'
                ansiColor('xterm') {
                    ansiblePlaybook(
                        playbook: 'provision/playbook.yml',
                        limit: '172.31.29.105',
                        installation: 'ansible',
                        inventory: 'provision/inventory.ini',
                        credentialsId: 'test',
                        colorized: true)
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
