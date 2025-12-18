pipelineJob('demojhipster-pipeline') {
    displayName('Demo JHipster Pipeline')
    description('Pipeline simple pour le projet demojhipster')

    triggers {
        scm('H/2 * * * *') // Scrute le repo toutes les 2 minutes
    }

    definition {
        cps {
            script('''
                pipeline {
                    agent any
                    stages {
                        stage('Checkout') {
                            steps {
                                git branch: 'main', url: 'https://github.com/bilonjea/demojhipster.git'
                            }
                        }
                        stage('Build') {
                            steps {
                                sh 'mvn clean install'
                            }
                        }
                        stage('Test') {
                            steps {
                                sh 'mvn test'
                            }
                        }
                    }
                }
            ''')
            sandbox()
        }
    }
}
