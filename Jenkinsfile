pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['khcassit01', 'khcassit02', 'khcassit03', 'khcasdev01', 'khcasdev02', 'khcasdev03'],
            description: 'Select environment'
        )
    }

    environment {
        CONFIG_FILE = "config/${params.ENV}.conf"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/TanSomnang/kh_db.git'
            }
        }

        stage('Load Config') {
            steps {
                script {
                    def props = readProperties file: "${CONFIG_FILE}"
                    env.DB_HOST   = props['DB_HOST']
                    env.DB_PORT   = props['DB_PORT']
                    env.DB_NAME   = props['DB_NAME']
                    env.RUNBOOK   = props['RUNBOOK']
                    env.CRED_ID   = props['JENKINS_CREDENTIAL_ID']
                }
            }
        }

        stage('Parse Runbook') {
            steps {
                script {
                    def runbookFile = "cas/runbook/${env.RUNBOOK}"
                    def runbookLines = []
                    runbookLines = readFile(runbookFile).split("\n").findAll { line -> line.trim() && !line.startsWith("#") }
                    echo "Scripts to execute: ${runbookLines}"
                }
            }
        }

        stage('Deploy Scripts') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${env.CRED_ID}", usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')]) {
                    script {
                        runbookLines.each { scriptPath ->
                            echo "Executing ${scriptPath}"
                            def status = sh(
                                script: "psql -h ${env.DB_HOST} -p ${env.DB_PORT} -U ${DB_USER} -d ${env.DB_NAME} -f cas/${scriptPath}",
                                returnStatus: true
                            )
                            if (status != 0) {
                                error "Execution failed for ${scriptPath} (exit code ${status})"
                            }
                        }
                    }
                }
            }
        }
    }
}