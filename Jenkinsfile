pipeline {
    agent any

    environment {
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
                                sourceFiles: '**/*',     // Copy all files and folders
                                removePrefix: '',        // Leave empty to avoid prefix issues
                                remoteDirectory: env.REMOTE_DIR,
                                execCommand: '''
                                    cd /var/www/ecomm
                                    chmod +x deploy.sh
                                    ./deploy.sh
                                ''',
                                flatten: false           // Keep directory structure
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

