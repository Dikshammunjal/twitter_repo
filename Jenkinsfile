pipeline {
    agent any
    tools { 
      maven 'MAVEN_HOME' 
      jdk 'JAVA_HOME' 
    }
    stages {
        
        
        stage('Push image to OCIR') { 
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
                script {
                   
                    
                
               
               
               
                
                    
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                sh "export GIT_COMMIT=${env.GIT_COMMIT}"
                echo "${params.REGISTRY_USERNAME}"
             
                echo "${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.OCIREGION="${params.REGION}"
                env.USERNAME="${params.REGISTRY_USERNAME}"
                env.PASSWORD="${params.REGISTRY_TOKEN}"
                env.IMAGE="${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.MICROSERVICENAME=  "${params.MIRCROSERVICE_NAME}"
                env.REGIONNAME= "${params.REGION}"
                env.EMAILID = "${params.REGISTRY_EMAIL}"
                    
                sh '/u01/shared/scripts/pipeline/microservices/base_oke_template_jenkins/pushimage.sh $PASSWORD $USERNAME $OCIREGION $MICROSERVICENAME $GIT_COMMIT $IMAGE'

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


                
            sh '/u01/shared/scripts/pipeline/microservices/base_oke_template_jenkins/update_deploy_microservices.sh $REGIONNAME.ocir.io $USERNAME $PASSWORD $EMAILID $MICROSERVICENAME-ns $MICROSERVICENAME $IMAGE 80 $MICROSERVICENAME-svc'
           
               }
            }
        
        }
}
