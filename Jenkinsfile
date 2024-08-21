pipeline {
    agent any

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
                        nexusUrl: 'http://3.7.46.54:8081',
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: nexusRepo,
                        version: "${readPomVersion.version}"
                    )
                }
            }
        }

        stage('docker image build') {
            steps {
                script {
                    sh 'docker image build -t saicharan6771/demoapp:v1.$BUILD_ID .'
                    sh 'docker image tag saicharan6771/demoapp:v1.$BUILD_ID saicharan6771/demoapp:latest'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                    sh 'docker image push saicharan6771/demoapp:v1.$BUILD_ID'
                    sh 'docker image push saicharan6771/demoapp:latest'
                }
            }
        }
    }
}
