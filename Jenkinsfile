pipeline {
    agent any

    environment {
        IMAGE_NAME = "${JOB_NAME}"
        IMAGE_TAG = "v1.${BUILD_ID}"
    }

    stages {
        // ... [Your existing stages]

        stage('Docker Image Build') {
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
                    sh 'docker login -u saicharan6771 -p Welcome@123'
                    sh "docker image push saicharan6771/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker image push saicharan6771/${IMAGE_NAME}:latest"
                }
            }
        }

        // New deployment stage
        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop and remove the existing container if it exists
                    sh "docker stop my-app || true"
                    sh "docker rm my-app || true"
                    
                }
            }
        }
    }
}
