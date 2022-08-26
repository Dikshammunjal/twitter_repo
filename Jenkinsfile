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
                            url: 'https://github.com/Dikshammunjal/twitter_repo.git'
                          ]],
                        branches: [ [name: '*/master'] ]
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
                            url: 'https://github.com/Dikshammunjal/twitter_repo.git'
                          ]],
                        branches: [ [name: '*/master'] ]
                      ])
                sh "docker login -u ${params.REGISTRY_USERNAME} -p ${params.REGISTRY_TOKEN} bom.ocir.io"
                sh "docker tag twitterfeed:${scmVars.GIT_COMMIT} ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                sh "docker push ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}" 
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                sh "export GIT_COMMIT=${env.GIT_COMMIT}"
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

            
            sh '''/u01/shared/scripts/pipeline/microservices/twitter_repo/update_deploy_microservices.sh iad.ocir.io '''${params.REGISTRY_USERNAME}''' '''${params.REGISTRY_TOKEN}''' diksha.m.munjal@oracle.com sehub-ns sehub sehub-ns sehub '''iad.ocir.io\/sehubjapacprod\/spring-projects\/spring-boot-to''' 8080 sehub-svc'''
           
               }
            }
        
        }
}
