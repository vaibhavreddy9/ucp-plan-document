#!groovy

properties([parameters([string(name: 'UCP_LIB_VERSION', defaultValue: 'master'), string(name: 'GLOBAL_LIB_VERSION', defaultValue: 'develop')])])
library "ucp-global-library@${params.UCP_LIB_VERSION}"
library "global-pipeline-library@${params.GLOBAL_LIB_VERSION}"

// Properties Configuration       
properties(getJobProperties())

pipeline {
    agent {
        label 'deploy-oso-slave'
    }

    environment {
        FORTIFY_VERSION = 'HP_Fortify_SCA_and_Apps_18.20'
        OC_VERSION = '3.9.0'
        PATH = '/tools/oc/oc-3.9.0:/tools/mysql/mysql-5.6.29-linux-glibc2.5-x86_64/bin:/tools/maven/apache-maven-3.2.3/bin:/tools/java/jdk1.8.0/bin:/tools/groovy/groovy-2.4.12/bin:/tools/docker/docker-1.11.2:/tools/ant/apache-ant-1.9.4/bin:/tools/oc/oc-3.2.1.17:/tools/mysql/mysql-5.6.29-linux-glibc2.5-x86_64/bin:/tools/java/jdk1.8.0/bin:/tools/groovy/groovy-2.4.12/bin:/tools/docker/docker-18.06.1:/usr/local/bin:/usr/bin'
    }

	stages {
		stage ('Build') {
			steps {
				script {
					mrCIBuild()					
				}
			}
		}
	}

    post {
        always {
            mrCINotifyAlways()
        }
        success {
            mrCINotifySuccess()
        }
        failure {
            mrCINotifyFailure()
        }
        unstable {
            mrCINotifyUnstable()
        }
        changed {
            mrCINotifyChanged()
        }
    }
}
