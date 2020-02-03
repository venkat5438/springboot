def getEnvVar(String paramName){
    return sh (script: "grep '${paramName}' env_vars/project.properties|cut -d'=' -f2", returnStdout: true).trim();
}
pipeline {
    environment {
        registry = "devopsbatch17/petclinic"
        registryCredential = 'devopsbatch17'
        dockerImage = ''
        PROJECT_ID= 'springboot-sample-265919'
        CLUSTER_NAME= 'springboot-sample'
        LOCATION= 'us-central1'
        CREDENTIALS_ID= 'JENKINS_GCLOUD_CREDENTIALS'
        JENKINS_GCLOUD_CRED_ID= 'JENKINS_GCLOUD_CRED_ID'


    }
    
    agent any

    stages {
        stage ('Pipeline beginning - Unit and Sonar stages'){
            stages {
                 stage('Init'){
                             steps{
                                    script{
                                        env.DOCKER_REGISTRY_URL=getEnvVar('DOCKER_REGISTRY_URL')
                                        env.JENKINS_DOCKER_CREDENTIALS_ID = getEnvVar('JENKINS_DOCKER_CREDENTIALS_ID')        
                                        env.JENKINS_GCLOUD_CRED_ID = getEnvVar('JENKINS_GCLOUD_CRED_ID')
                                        env.GCLOUD_PROJECT_ID = getEnvVar('GCLOUD_PROJECT_ID')
                                        env.JENKINS_GCLOUD_CRED_LOCATION = getEnvVar('JENKINS_GCLOUD_CRED_LOCATION')

                                    }

                                }
                                }
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
                        sh 'docker version'
                        sh 'docker images'
                    }
                }
                stage('Building image') {
                    steps{
                        script{
                            sh 'docker build -t "devopsbatch17/petclinic:$BUILD_NUMBER" .'
                            sh 'docker images'
                        }
                            
                    }
                }
                stage('Cleanup'){
                    steps{
                            sh  '''
                                 docker image prune --all --filter until=1h --force
                                 docker rmi $(docker images -f 'dangling=true' -q) || true
                                 docker rmi $(docker images | sed 1,2d | awk '{print $3}') || true
                                '''
                    }
                }
                stage('Store artifact') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'devopsbatch17', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR')]) 
                        {
                            sh 'docker login --username $DOCKER_HUB_CREDENTIALS_USR --password $DOCKER_HUB_CREDENTIALS_PSW'
                            sh 'docker push "devopsbatch17/petclinic:$BUILD_NUMBER"'
                            sh 'kubectl create secret docker-registry registry.hub.docker.com --docker-server=https://registry.hub.docker.com --docker-username=$DOCKER_HUB_CREDENTIALS_USR --docker-password=$DOCKER_HUB_CREDENTIALS_PSW --docker-email=devopsbatch17@gmail.com --dry-run -o yaml|/usr/local/bin/kubectl apply -f -'
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
                                gcloud components install kubectl
                                gcloud container clusters get-credentials springboot-cluster
                                kubectl get ns
                                ./changeTag.sh $BUILD_NUMBER
                                kubectl apply -f deployment_buildversion.yml
                                kubectl apply -f service-definition.yml
                            """
                         }
                            
                        }
                    }
                

            }

        }
    }
}