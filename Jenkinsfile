pipeline {
    agent any

    environment {
        IMAGE_NAME = "${JOB_NAME}"
        IMAGE_TAG = "v1.${BUILD_ID}"
        DEPLOY_ENV = "${params.DEPLOY_ENV}" // Parameter for the deployment environment
    }

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['QA', 'UAT', 'Prod'], description: 'Select the deployment environment')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker image build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker image tag ${IMAGE_NAME}:${IMAGE_TAG} saicharan6771/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker image tag ${IMAGE_NAME}:${IMAGE_TAG} saicharan6771/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    sh 'docker login -u saicharan6771 -p $DOCKER_HUB_PASSWORD'
                    sh "docker image push saicharan6771/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker image push saicharan6771/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    def port = ""
                    if (DEPLOY_ENV == 'QA') {
                        port = "8082"
                    } else if (DEPLOY_ENV == 'UAT') {
                        port = "8083"
                    } else if (DEPLOY_ENV == 'Prod') {
                        port = "8081"
                    }
                    
                    // Stop and remove the existing container if it exists
                    sh "docker stop my-app-${DEPLOY_ENV} || true"
                    sh "docker rm my-app-${DEPLOY_ENV} || true"
                    
                    sh "docker run -d -p ${port}:9099 --name my-app-${DEPLOY_ENV} saicharan6771/${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
