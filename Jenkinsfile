pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/elvin98bc/devops-cicid-multitier-eks.git'
            }
        }

        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test -DskipTests=true"
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=bankapp -Dsonar.projectKey=bankapp \
                        -Dsonar.java.binaries=target'''
                }
            }
        }

        stage('Build') {
            steps {
                sh "mvn package -DskipTests=true"
            }
        }
        
        stage('Public Artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'settings-maven', maven: 'maven3', traceability: true) {
                    sh "mvn deploy -DskipTests=true"
                }
            }
        }
        
        stage('Docker Build & Tag') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    sh "docker build -t elvin98bc/bankapp:latest ."
                }
                }
            }
        }
        
        stage('Trivay Image Scan') {
            steps {
                sh "trivy image --format table -o image.html elvin98bc/bankapp:latest"
            }
        }

        stage('Docker Push') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    sh "docker push elvin98bc/bankapp:latest"
                }
                }
            }
        }
        
        stage('K8-Deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'devops-cluster', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://312B546CCCDAB80B482D733191652627.gr7.ap-southeast-1.eks.amazonaws.com') {
                    sh 'pwd && ls -la'
                    sh 'kubectl apply -f k8s-yaml/deployment-service.yml'
                    sleep 20
                }
            }
        }

        stage('K* Verify the Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'devops-cluster', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://312B546CCCDAB80B482D733191652627.gr7.ap-southeast-1.eks.amazonaws.com') {
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
                }
            }
        }
        
    }
    
    // post {
    // always {
    //     script {
    //         def jobName = env.JOB_NAME
    //         def buildNumber = env.BUILD_NUMBER
    //         def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
    //         def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
            
    //         def body = """
    //             <html>
    //             <body>
    //             <div style="border: 4px solid ${bannerColor}; padding: 10px;">
    //             <h2>${jobName} - Build ${buildNumber}</h2>
    //             <div style="background-color: ${bannerColor}; padding: 10px;">
    //             <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
    //             </div>
    //             <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
    //             </div>
    //             </body>
    //             </html>
    //         """

    //         emailext (
    //             subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
    //             body: body,
    //             to: 'elvin98bc@gmail.com',
    //             from: 'elvin98bc@gmail.com',
    //             replyTo: 'elvin98bc@gmail.com',
    //             mimeType: 'text/html'
    //         )
    //     }
        
    // }
    // }
}