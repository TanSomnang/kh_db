pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/TanSomnang/kh_db.git'
            }
        }
        stage('Run SQL Script') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'pg-cred', 
                                                 usernameVariable: 'PGUSER', 
                                                 passwordVariable: 'PGPASSWORD')]) {
                    sh '''
                        export PGPASSWORD=$PGPASSWORD
                        psql -h 127.0.01 -U $PGUSER -d postgres -f insert_records.sql
                    '''
                }
            }
        }
    }
}
