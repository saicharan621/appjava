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
        stage('Integration Testing')
            steps {
                sh 'mvn verify-DskipUnitTests'
            }
        }         
    }
}
