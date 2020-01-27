pipeline {
    environment {
    registry = "devopsbatch17/petclinic"
    registryCredential = 'dockerhub'
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
                        echo "Here is the Sonar exec!"
                    }
                }

                stage('Unit Tests') {
                    steps {
                        sh './mvnw test'
                    }
                }

                stage('Building artifact') {
                    steps {
                        sh './mvnw verify'
                       // sh 'docker build -t devopsbatch17/petclinic .'
                    }
                }
                stage('Building image') {
                    steps{
                        script {
                            dockerImage = docker.build registry + ":$BUILD_NUMBER"
                        }
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
        stage ('Integration tests stage') {
            when {
                anyOf {
                    //environment name: 'gitlabBranch', value: 'developer';
                    environment name: 'gitlabBranch', value: 'master'
                }
            }
            stages {
                stage('Running integration tests') {
                    steps {
                        echo "Here are the tests"
                    }
                }
                stage('Running functional tests') {
                    steps {
                        echo "Here are the func tests"
                    }
                }
            }
        }
        stage ('Deploy stage') {
            stages {
              stage ('create docker network') {
                 steps {
                   sh 'if ! [ "$(docker network list | grep skillsmatrix)" ]; then docker network create skillsmatrix; fi'
                 }
               }
               stage('run db container') {
                steps {
                  sh 'docker pull bitnami/mongodb:latest'
                  sh 'if [ "$(docker ps -a | grep mongodb)" ]; then docker stop mongodb && docker rm mongodb; fi'
                  sh 'if [ "$(docker ps -aq -f status=exited -f name=mongodb)" ]; then docker rm mongodb; fi'
                  sh 'docker run --network skillsmatrix --name mongodb -itd  -u root -v /data:/bitnami -p 27017:27017 bitnami/mongodb:latest'
                }
              }
              stage('run container') {
                steps {
                    withCredentials([usernamePassword(credentialsId: 'docker_hub_skills_matrix', passwordVariable: 'DOCKER_HUB_CREDENTIALS_PSW', usernameVariable: 'DOCKER_HUB_CREDENTIALS_USR')]) {
                        sh 'docker login --username $DOCKER_HUB_CREDENTIALS_USR --password $DOCKER_HUB_CREDENTIALS_PSW'
                        sh 'if [ "$(docker ps -a | grep backenddevskill)" ]; then docker stop backenddevskill && docker rm backenddevskill; fi'
                        sh 'if [ "$(docker ps -aq -f status=exited -f name=backenddevskill)" ]; then docker rm backenddevskill; fi'
                        sh 'if [ "$(docker images -q $DOCKER_HUB_CREDENTIALS_USR/skills-matrix-java-skill:$(grep -Eo "([0-9]\\.[0-9]+\\.[0-9]+)[-SNAPSHOT]*" ~/version.properties))" ]; then docker rmi -f $DOCKER_HUB_CREDENTIALS_USR/skills-matrix-java-skill:$(grep -Eo "([0-9]\\.[0-9]+\\.[0-9]+)[-SNAPSHOT]*" ~/version.properties); fi'
                        sh 'docker run --network skillsmatrix -e SPRING_PROFILES_ACTIVE=dev -p 8080:8080 --name backenddevskill -itd $DOCKER_HUB_CREDENTIALS_USR/skills-matrix-java-skill:$(grep -Eo "([0-9]\\.[0-9]+\\.[0-9]+)[-SNAPSHOT]*" ~/version.properties)'
                    }
                  }
               }
            }
        }
    }
    post {
        always {
            cleanWs deleteDirs: true
        }
        failure {
            updateGitlabCommitStatus name: 'build', state: 'failed'
        }
        success {
            updateGitlabCommitStatus name: 'build', state: 'success'
            sleep(90)
            sh 'curl -fsS localhost:8080/actuator/health | grep UP'
            sh 'curl -fsS localhost:27017 > /dev/null'
        }
    }
}