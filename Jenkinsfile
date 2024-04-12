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
                sh 'mvn verify -DskipTests'
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
    post {
        always {
            script {
                // Use the 'withSonarQubeEnv' step with the correct installation name
                withSonarQubeEnv('Sonar-api') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
    }
}
