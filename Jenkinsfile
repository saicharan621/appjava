pipeline {
    agent any
    
    stages {
        stage('Git Checkout') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/saicharan621/appjava.git'
                }
            }
        }
        stage('Unit Testing') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        stage('Integration Testing') {
            steps {
                script {
                    sh 'mvn verify -DskipTests'
                }
            }
        }
        stage('Maven Build') {
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }
    }
    post {
        always {
            script {                
                // Perform SonarQube analysis
                withSonarQubeEnv('sonarserver') {
                    sh 'mvn clean package sonar:sonar'
                }
                // Wait for Quality Gate status
                stage('Quality Gate Status') {
                    steps {
                        script {
                            waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                        }
                    }
                }
            }
        }
    }
}
