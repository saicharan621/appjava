pipeline {
    agent any

    environment {
        IMAGE_NAME = "${JOB_NAME}"
        IMAGE_TAG = "v1.${BUILD_ID}"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/appjava.git'
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Integration Testing') {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Static Code Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'sonarqube server', credentialsId: 'sonarqube-api') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }

        stage('Quality Gate Status') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage('Upload WAR to Nexus') {
            steps {
                script {
                    def readPomVersion = readMavenPom file: 'pom.xml'
                    def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshot" : "nexus-reposite"
                    nexusArtifactUploader(
                        artifacts: [
                            [
                                artifactId: 'springboot',
                                classifier: '',
                                file: 'target/Uber.jar',
                                type: 'jar'
                            ]
                        ],
                        credentialsId: 'nexus-auth',
                        groupId: 'com.example',
                        nexusUrl: '3.7.46.54:8081',
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: nexusRepo,
                        version: "${readPomVersion.version}"
                    )
                }
            }
        }

        stage('Docker Image Build') {
            steps {
                script {
                    sh "docker image build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker image tag ${IMAGE_NAME}:${IMAGE_TAG} saicharanakkapeddi/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker image tag ${IMAGE_NAME}:${IMAGE_TAG} saicharanakkapeddi/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    
                        sh 'docker login -u saicharan6771 -p Welcome@123'
                        sh "docker image push saicharanakkapeddi/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker image push saicharanakkapeddi/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }

