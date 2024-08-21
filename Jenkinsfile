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
                    def imageName = "${JOB_NAME}"
                    def imageTag = "v1.${BUILD_ID}"
                    sh "docker image build -t ${imageName}:${imageTag} ."
                    sh "docker image tag ${imageName}:${imageTag} saicharanakkapeddi/${imageName}:${imageTag}"
                    sh "docker image tag ${imageName}:${imageTag} saicharanakkapeddi/${imageName}:latest"
                }
            }
        }
        stage ('push docker image to dockerhub') {
            steps {

                script{
                    withCredentials([string(credentialsId: 'git_creds', variable: 'docker_hub_cred')]) {
                        sh 'docker login -u saicharan6771 -p ${docker_hub_cred}'
                        sh 'docker image push saicharanakkapeddi/${imageName}:${imageTag}'
                        sh 'docker image push saicharanakkapeddi/${imageName}:latest'
                 }
                }

            }
        }
    }
}
