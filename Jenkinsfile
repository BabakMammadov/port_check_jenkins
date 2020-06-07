pipeline {
    agent { label 'master'}

    stages {
        stage('Setup Jenkins job name') {
            steps {
                script {
                    currentBuild.displayName = "${GIT_BRANCH}-${BUILD_NUMBER}"
                }
            }
        }
        stage ('execute telnet automation script') {
            steps {
                sh './port_check_automation.sh ${src_addr} ${dest_addr_ports}'
            }
        }
    }
    post {
        always {
            cleanWs()
            script {
                currentBuild.result = currentBuild.result ?: 'SUCCESS'
                notifyBitbucket(
                        credentialsId: '5563c8eb-e93d-42ee-8130-b5b534dfc531',
                        disableInprogressNotification: false,
                        stashServerBaseUrl: 'https://bitbucket.kapitalbank.az'
                )
            }
        }
    }

}