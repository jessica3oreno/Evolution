pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                checkout scm
                sh 'dotnet build ./Evolution/Evolution.csproj --output ./out'
                stash "${BUILD_NUMBER}"
            }
        }
        stage('Unit Test') {
            steps {
                unstash "${BUILD_NUMBER}"
                sh 'dotnet test ./Evolution.Test.Unit/Evolution.Test.Unit.csproj --filter Category=unit --logger "trx;LogFileName=results\\tests_unit.xml"'
                stash "${BUILD_NUMBER}"
            }
        }
        stage('Quality') {
            steps {
                sh 'dotnet /opt/sonarscanner-msbuild/SonarScanner.MSBuild.dll begin /k:"evolution"'
                sh 'dotnet build'
                sh 'dotnet /opt/sonarscanner-msbuild/SonarScanner.MSBuild.dll end'
            }
        }
        stage('Integration Test - Oracle') {
            environment {
                String dbName="evolution"
                String oraUser="appUser"
                String oraPwd="appPassword"
                String oraPort1="6666"
                String oraPort2="6667"
                String src = 'sys/Oradoc_db1@localhost:1521/ORCLCDB.localdomain'
                String command = "'source /home/oracle/.bashrc; sqlplus ${src} as sysdba @/SetupOracle.sql; exit \$?'"
                String dockerCmd = "docker exec evolution bash -c ${command}"
            }
            steps {

                unstash "${BUILD_NUMBER}"
                //Startup Docker container for database
                sh "docker run -d --name ${env.dbName} -p ${env.oraPort1}:1521 -p ${env.oraPort2}:5500 -e ORACLE_SID=${env.oraInstance}	store/oracle/database-enterprise:12.2.0.1"

                timeout(time: 30, unit: 'MINUTES') {
                    sh 'chmod 700 dockerHealth.sh'
                    sh './dockerHealth.sh ${dbName}'
                }

                //Setup test user
                sh "docker cp ./Setup/SetupOracle.sql ${dbName}:SetupOracle.sql"
                retry(5) {
                    script {
                        try
                        {
                            sleep 120
                            println "${dockerCmd}"
                            sh "${dockerCmd}"
                        }
                        catch(ex)
                        {
                            println ex
                            sleep 15
                            throw ex
                        }
                    }
                }
                
                sh "dotnet test ./Evolution.Test.Unit/Evolution.Test.Unit.csproj --filter Category=integration --logger \"trx;LogFileName=results\\tests_integration.xml\""

                //Breakdown container
                sh "docker stop ${env.dbName}"
                sh "docker rm ${env.dbName}"
            }
        }
    }
}