pipeline {
    agent any
    tools { 
      maven 'MAVEN_HOME' 
      jdk 'JAVA_HOME' 
    }
    stages {
        
        stage('Build') { 
            steps {
                sh "mvn install -DskipTests" 
            }
        }
        stage('Create docker image') {
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
                script {
                    def scmVars = checkout([
                        $class: 'GitSCM',
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: "${params.GIT_REPO_URL}"
                          ]],
                        branches: [ [name: "*/${params.GIT_REPO_BRANCH}"] ]
                      ])
                sh "docker build -f Dockerfile -t twitterfeed:${scmVars.GIT_COMMIT} ." 
                }
            }
        }
        stage('Push image to OCIR') { 
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
                script {
                    def scmVars = checkout([
                        $class: 'GitSCM',
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: "${params.GIT_REPO_URL}"
                          ]],
                        branches: [ [name: "*/${params.GIT_REPO_BRANCH}"] ]
                      ])
                sh "docker login -u ${params.REGISTRY_USERNAME} -p ${params.REGISTRY_TOKEN} bom.ocir.io"
                sh "docker tag twitterfeed:${scmVars.GIT_COMMIT} ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                sh "docker push ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}" 
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                sh "export GIT_COMMIT=${env.GIT_COMMIT}"
                echo "${params.REGISTRY_USERNAME}"
             
                echo "${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.USERNAME="${params.REGISTRY_USERNAME}"
                env.PASSWORD="${params.REGISTRY_TOKEN}"
                env.IMAGE="${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.MICROSERVICENAME=  "${params.MIRCROSERVICE_NAME}"
                env.REGIONNAME= "${params.REGION}"
                env.EMAILID = "${params.REGISTRY_EMAIL}"
                }
               }
            }
        stage('Deploy OKE') { 
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
            echo 'Deploy app to OKE Cluster'


                
            sh '/u01/shared/scripts/pipeline/microservices/twitter_repo/update_deploy_microservices.sh $REGIONNAME.ocir.io $USERNAME $PASSWORD $EMAILID $MICROSERVICENAME-ns $MICROSERVICENAME $IMAGE 80 $MICROSERVICENAME-svc'
           
               }
            }
        
        }
}
