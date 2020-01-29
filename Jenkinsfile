pipeline {
    environment {
        registry = "devopsbatch17/petclinic"
        registryCredential = 'devopsbatch17'
        dockerImage = ''
        PROJECT_ID= 'springboot-sample-265919'
        CLUSTER_NAME= 'springboot-sample'
        LOCATION= 'us-central1'
        CREDENTIALS_ID= 'JENKINS_GCLOUD_CREDENTIALS'


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
                            sh '/usr/local/bin/docker build -t "devopsbatch17/petclinic:$BUILD_NUMBER" .'
                            sh '/usr/local/bin/docker images'
                        }
                            
                    }
                }
                stage('Cleanup'){
                    steps{
                            sh  '''
                                 /usr/local/bin/docker image prune --all --filter until=1h --force
                                 /usr/local/bin/docker rmi $(/usr/local/bin/docker images -f 'dangling=true' -q) || true
                                 /usr/local/bin/docker rmi $(/usr/local/bin/docker images | sed 1,2d | awk '{print $3}') || true
                                '''
                    }
                }
                stage('Store artifact') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'devopsbatch17', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR')]) 
                        {
                            sh '/usr/local/bin/docker login --username $DOCKER_HUB_CREDENTIALS_USR --password $DOCKER_HUB_CREDENTIALS_PSW'
                            sh '/usr/local/bin/docker push "devopsbatch17/petclinic:$BUILD_NUMBER"'
                            sh '/usr/local/bin/docker logout'
                        }
                    }
                }

                stage('Deploy to GKE test cluster') {
                    steps{
                        withCredentials([file(credentialsId: "${JENKINS_GCLOUD_CRED_ID}", variable: 'JENKINSGCLOUDCREDENTIAL')])
                        {
                            sh """
                                gcloud auth activate-service-account --key-file=${JENKINSGCLOUDCREDENTIAL}
                                gcloud config set compute/zone us-central1
                                gcloud config set project springboot-sample-265919
                                gcloud container clusters get-credentials springboot-cluster
                                kubectl get ns
                                kubectl create secret docker-registry registry.hub.docker.com --docker-server=https://registry.hub.docker.com --docker-username=$DOCKER_HUB_CREDENTIALS_USR --docker-password=$DOCKER_HUB_CREDENTIALS_PSW --docker-email=devopsbatch17@gmail.com --dry-run -o yaml|kubectl apply -f -
                                ./changeTag.sh $BUILD_NUMBER
                                kubectl apply -f deployment.yml
                                kubectl apply -f service-definition.yml
                                gcloud auth revoke --all
                            """
                         }
                            
                        }
                    }
                

            }

        }
    }
}