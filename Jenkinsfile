pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['khcassit01', 'khcassit02', 'khcassit03', 'khcasdev01', 'khcasdev02', 'khcasdev03'], description: 'Select environment')
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
                    env.DB_USER   = props['DB_USER']
                    env.DB_NAME   = props['DB_NAME']
                    env.DB_PASS   = props['DB_PASS']
                    env.RUNBOOK   = props['RUNBOOK']
                }
            }
        }

        stage('Parse Runbook') {
            steps {
                script {
                    def runbookFile = "cas/runbook/${env.RUNBOOK}"
                    runbookLines = readFile(runbookFile)
                        .split("\n")
                        .findAll { line -> line.trim() && !line.startsWith("#") }
                    echo "Scripts to execute: ${runbookLines}"
                }
            }
        }

        stage('Deploy Scripts') {
            steps {
                script {
                    runbookLines.each { scriptPath ->
                        echo "Executing ${scriptPath}"
                        withEnv(["PGPASSWORD=${env.DB_PASS}"]) {
                            def status = sh(
                                script: "psql -h ${env.DB_HOST} -p ${env.DB_PORT} -U ${env.DB_USER} -d ${env.DB_NAME} -f cas/${scriptPath}",
                                returnStatus: true
                            )
                            if (status != 0) {
                                error "Execution failed for ${scriptPath} (exit code ${status})"
                            }
                        }

                        // sh """
                        // PGPASSWORD=${env.DB_PASS} psql -h ${env.DB_HOST} -p ${env.DB_PORT} -U ${env.DB_USER} -d ${env.DB_NAME} -f cas/${scriptPath}
                        // """
                    }
                }
            }
        }
    }
}