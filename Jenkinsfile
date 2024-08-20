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
                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: 'springboot',
                            classifier: '',
                            file: 'target/Uber.jar',
                            type: 'jar'
                        ]
                    ],
                    credentialsId: 'nexus-auth',
                    groupId: 'com.example',
                    nexusUrl: 'http://13.126.97.72:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: 'maven-releases',
                    version: '1.0.0'
                }
            }
        }
    }
}
