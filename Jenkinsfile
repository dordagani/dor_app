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
