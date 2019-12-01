#!groovy​

def customImage

stage ('Git') {
    node {
        echo '> Checking out the Git version control ...'
        checkout scm
    }
}

stage ('Build') {
    node {
        echo '> Building the docker image ...'
        customImage = docker.build("dordagani/flask_app-image:B${BUILD_NUMBER}")
    }
}

stage ('Unit Test') {
    node {
        echo '> Doing Unit Test ...'
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
            sh "docker rmi dordagani/flask_app-image:B${BUILD_NUMBER}"
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
