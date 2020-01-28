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
                        script{
                            def customImage =  '/usr/local/bin/docker.build registry + ":$BUILD_NUMBER"'
                            sh '/usr/local/bin/docker images'
                        }
                            
                    }
                }
                stage('Store artifact') {
                    steps {
                        withDockerRegistry([ credentialsId: "devopsbatch17", url: "https://registry.hub.docker.com" ]) {
                            sh '/usr/local/bin/docker push registry + ":$BUILD_NUMBER"'
                        }
                    }
                }

            }

        }
}
}