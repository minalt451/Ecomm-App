pipeline {
    agent any

    stages {

        stage('Clone Code') {
            steps {
                git url: 'https://github.com/minalt451/Ecomm-App.git', branch: 'main'
            }
        }

        stage('Copy Code to EC2') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'EC2-Production',
                        transfers: [
                            sshTransfer(
                                sourceFiles: '**/*',
                                removePrefix: '',
                                remoteDirectory: '',
                                execCommand: '''
                                    cd /var/www/ecomm
                                    chmod +x deploy.sh
                                    ./deploy.sh
                                '''
                            )
                        ]
                    )
                ])
            }
        }
    }
}
