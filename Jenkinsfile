pipeline {
    agent any
    environment {
        // Defining the credentials ID for accessing the Git repository
//        GIT_CREDENTIALS_ID = 'githubCred'
        SONAR_HOME = tool "sonarScannerTool"
        DOCKERHUB_TOKEN = credentials('dockerHubToken')
        DOCKER_USERNAME = credentials('dockerHubUser')
        DOCKER_IMAGE_TAG = 'v1.0' // Specify the version or tag

    }

    stages {
         stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("sonarqube-server-system-sync") {
                    sh '$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=notepad-app -Dsonar.projectKey=notepad-app -X'
                }
            }
        }
    //   stage('SonarQube Quality Gates') {
    //        steps {
    //            timeout(time: 45, unit: "MINUTES"){
    //              waitForQualityGate abortPipeline: false //true when developer writes code :)
    //            }
    //        }
    //    }
         stage('Dependecy Scanner: OWASP') {
            steps {
                echo 'Vulnerability checking in the app dependencies'
//                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'OWASP'
//                dependencyCheckPublisher pattern: '**/owasp-dependency-check-report.xml'
            }
        }
         stage('Build & Test') {
            steps {
                echo 'Building the app'
//                sh 'docker --version'
                // sh 'docker build -t notepad-app:$DOCKER_IMAGE_TAG .'
                sh 'docker build -t notepad-app .'

            }
        }
         stage('Trivy Image Scanner') {
            steps {
                echo 'Scanning the Build Artifact: Only do this when you have enough space else face error'
//                sh 'trivy image notepad-app'
            }
        }
         stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub the app'
                withCredentials([usernamePassword(credentialsId: "dockerHubToken", usernameVariable: "DOCKER_USERNAME", passwordVariable: "DOCKERHUB_TOKEN")]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKERHUB_TOKEN"
                    sh "docker tag notepad-app $DOCKER_USERNAME/notepad-app:$DOCKER_IMAGE_TAG" 
                    sh "docker push $DOCKER_USERNAME/notepad-app:$DOCKER_IMAGE_TAG" 
                    // sh "docker tag notepad-app $DOCKER_USERNAME/notepad-app:latest" 
                    // sh "docker push $DOCKER_USERNAME/notepad-app:latest" 
                }
            }
        }
         stage('Deploy') {
            steps {
                echo 'Deployed the app'
                sh "docker-compose down && docker-compose up -d --build"
            }
        }
    }
}

