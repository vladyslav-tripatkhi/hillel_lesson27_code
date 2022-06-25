def image_name = ""

pipeline {
    agent any

    environment {
        EXAMPLE_ENV = "example env"
    }

    parameters {
        string(
            name: "IMAGE_NAME",
            defaultValue: "example-app",
            description: "Resulting docker image name"
        )

        string(
            name: "REGISTRY_NAME",
            defaultValue: "507676015690.dkr.ecr.us-east-1.amazonaws.com",
            description: "Registry name"
        )

        choice(
            name: "AWS_REGION",
            choices: ["us-east-1", "us-west-1"],
            description: "AWS region name",
        )
    }

    stages {
        stage("Checkout") {
            steps {
                script {
                    if (params.IMAGE_NAME.isEmpty()) {
                        // error("Image name is empty, failing build")
                        image_name = "example-app"
                    } else {
                        image_name = params.IMAGE_NAME
                    }

                    if (!params.REGISTRY_NAME.isEmpty()) {
                        image_name = "${params.REGISTRY_NAME}/${image_name}"
                    }
                }
                sh "echo Hello from ${env.STAGE_NAME}"
                checkout([
                    $class: 'GitSCM',
                    branches: [[
                        name: '*/master'
                    ]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/vladyslav-tripatkhi/react-redux-realworld-example-app.git'
                    ]]
                ])
            }
        }

        stage("Build") {
            steps {
                echo "This is a second stage in build number ${env.BUILD_NUMBER}"
                // sh "docker build -t ${image_name}:${env.BUILD_ID} ."
                script {
                   docker_image = docker.build("${image_name}:${env.BUILD_ID}")
                }
            }
        }

        stage("Push") {
            when {
                expression { !params.REGISTRY_NAME.isEmpty() }
            }
            steps {
                // input("Push docker image to registry?")
                echo "Publish docker image"
                script {
                    docker.withRegistry("https://${image_name}", "ecr:${params.AWS_REGION}:vlad-keypair") {
                        docker.image("${image_name}:${env.BUILD_ID}").push()
                    }
                }
            }
        }

        stage('Parallel execution') {
            parallel {
                stage("Stage III") {
                    steps {
                        sh "echo This is the last stage ${image_name}, ${params.AWS_REGION}"
                    }
                }

                stage("Stage IV") {
                    steps {
                        echo "This is really the last stage ${image_name}"
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