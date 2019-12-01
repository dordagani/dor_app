#!groovy​

def customImage
def DOCKER_HUB_USER="dordagani"
def APP_NAME="flask_app"

stage ('Git') {
    node {
        echo '> Checking out the Git version control ...'
        checkout scm
    }
}

stage ('Build') {
    node {
        echo '> Building the docker image ...'
        customImage = docker.build("${DOCKER_HUB_USER}/${APP_NAME}-image:B${BUILD_NUMBER}")
    }
}

stage ('Unit Test') {
    node {
        echo '> Doing Unit Test ...'
        containerID = sh(returnStdout: true, script: 'docker run -d \
        dordagani/flask_app-image:B${BUILD_NUMBER} py.test --junitxml=/data/test_result.xml \
        ').trim()
        echo "Container ID is ==> ${containerID}"
        sh "docker stop ${containerID}"
        sh "docker cp ${containerID}:/data/test_result.xml test_result.xml"
        sh "docker rm ${containerID}"
        step([$class: 'JUnitResultArchiver', testResults: 'test_result.xml'])
    }
}

if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
    
    stage ('Approval') {
        timeout(time:3, unit:'DAYS') {
            input 'Do I have your approval for push & deployment?'
        }
    }

    stage ('Push') {
        node {
            echo '> Pushing to Docker Hub ...'
            docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-hub-credentials') {
              customImage.push()
              customImage.push('latest')
            }
            sh "docker rmi ${DOCKER_HUB_USER}/${APP_NAME}-image:B${BUILD_NUMBER}"
        }
    }

    stage ('Deploy') {
        node {
            echo '> Deploying the docker container ...'
            ansiColor('xterm') {
                ansiblePlaybook(
                    playbook: 'provision/playbook.yml',
                    installation: 'ansible',
                    inventory: 'provision/inventory.ini',
                    credentialsId: 'test',
                    colorized: true)
            }
        }
    }

}


  if ( currentBuild.result == "SUCCESS" ) {
    echo "Job: ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was successful"
  }
//   else if( buildResult == "FAILURE" ) { 
//     slackSend color: "danger", message: "Job: ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was failed"
//   }
//   else if( buildResult == "UNSTABLE" ) { 
//     slackSend color: "warning", message: "Job: ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} was unstable"
//   }
//   else {
//     slackSend color: "danger", message: "Job: ${env.JOB_NAME} with buildnumber ${env.BUILD_NUMBER} its resulat was unclear"	
//   }
// }
