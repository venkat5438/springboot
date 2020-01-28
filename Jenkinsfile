pipeline {
    environment {
        registry = "devopsbatch17/petclinic"
        registryCredential = 'devopsbatch17'
        dockerImage = ''
    }
    
    agent any

    stages {
        stage ('Pipeline beginning - Unit and Sonar stages'){
            stages {
                stage('Checkout') {
                    steps {
                        git branch: 'master', credentialsId: '42e2540c-bd45-4b1f-a50e-5ebf09baef8f', url: 'https://github.com/venkat5438/springboot.git'
                    }
                }

                stage('Running Sonar') {
                    steps {
                        echo "Here is the Sonar exect!"
                    }
                }

                stage('Unit Tests') {
                    steps {
                        sh './mvnw test'
                    }
                }

                stage('Building artifact') {
                    steps {
                        sh './mvnw package'
                        sh '/usr/local/bin/docker version'
                        sh '/usr/local/bin/docker images'
                    }
                }
                stage('Building image') {
                    steps{
                            sh '/usr/local/bin/docker.build registry + ":$BUILD_NUMBER"'
                    }
                }
                stage('Store artifact') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'devopsbatch17', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR')]) {
                            sh 'docker login --username $DOCKER_HUB_CREDENTIALS_USR --password $DOCKER_HUB_CREDENTIALS_PSW'
                            sh 'docker push $DOCKER_HUB_CREDENTIALS_USR/petclinic:latest'
                        }
                    }
                }

            }

        }
}
}