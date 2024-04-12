pipeline{
    
    agent any 
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/saicharan621/appjava.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                    }
                }
            }
            stage ('upload war file to nexus'){

                  steps{

                     script{
                         nexusArtifactUploader artifacts: 
                         [
                            [
                                artifactId: 'springboot', 
                                classifier: '', file: 'target/Uber.jar', 
                                type: 'jar'
                                ]
                                ], 
                                credentialsId: 'd35078aa-dd03-4696-9297-74b67566e558',
                                groupId: 'com.example', nexusUrl: '3.111.188.94:8081', 
                                nexusVersion: 'nexus2', 
                                protocol: 'http', 
                                repository: 'http://3.111.188.94:8081/repository/demoapp-release/', 
                                version: '1.0.0'
                     }                    
                  }
            }
        }
        
}