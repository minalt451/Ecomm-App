pipeline {
    agent any

    environment {
        // SSH server name from Manage Jenkins → Configure → Publish over SSH
        SSH_SERVER = 'EC2-Production'
        REMOTE_DIR = '/var/www/ecomm'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/minalt451/Ecomm-App.git', branch: 'main'
            }
        }

        stage('Copy Code to EC2') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: env.SSH_SERVER,
                        transfers: [
                            sshTransfer(
                                sourceFiles: '**/*',          // Copy all files and folders
                                removePrefix: 'Ecomm-App',    // Remove the root folder prefix
                                remoteDirectory: env.REMOTE_DIR,
                                execCommand: '''
                                    cd /var/www/ecomm
                                    chmod +x deploy.sh
                                    ./deploy.sh
                                ''',
                                flatten: false                // Keep directory structure
                            )
                        ],
                        usePromotionTimestamp: false,
                        verbose: true
                    )
                ])
            }
        }
    }
}
