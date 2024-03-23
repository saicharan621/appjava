pipeline {
    agent any
    
    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/appjava.git'
            }
        }
        stage('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        stage('Unit Testing') {
            steps {
                sh 'mvn verify -DskipUnitTests'
            }    

    
        }
    }
    
}
