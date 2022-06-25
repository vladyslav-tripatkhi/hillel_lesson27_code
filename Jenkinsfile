def my_tmp_var  = ""

pipeline {
    agent any

    environment {
        MY_ENV = "test env 01"
        REGISTRY_NAME = "507676015690.dkr.ecr.us-east-1.amazonaws.com"
    }

    parameters {
        string(
            name: 'IMAGE_NAME',
            defaultValue: 'example-app',
            description: 'Image name'
        )
    }

    stages {
        stage("SCM") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[
                        name: '*/master'
                    ]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/vladyslav-tripatkhi/react-redux-realworld-example-app.git'
                    ]]])
            }
        }

        stage("Build") {
            steps {
                echo "Building; Build ID: ${env.BUILD_ID}"
                // sh "docker build -t ${params.IMAGE_NAME}:${env.BUILD_ID} ."
                script {
                    my_tmp_var = "Hello! ${env.MY_ENV}"
                    docker.build("${env.REGISTRY_NAME}/${params.IMAGE_NAME}:${env.BUILD_ID}")
                }

                echo "Hello from ${my_tmp_var}"
            }
        }

        stage("Push") {
            steps {
                input("Proceed with deployment?")
                echo "Deploying ${env.MY_ENV}"
                script {
                    docker.withRegistry("https://${env.REGISTRY_NAME}", 'ecr:us-east-1:vlad-terraform-user') {
                        docker.image("${env.REGISTRY_NAME}/${params.IMAGE_NAME}:${env.BUILD_ID}").push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}