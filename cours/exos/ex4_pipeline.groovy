pipelineJob('cargo-tms-pipeline') {
    displayName('Cargo TMS Pipeline')
    description('Pipeline simple pour le projet Cargo TMS')

    // Scrutation SCM toutes les minutes
    triggers {
        scm('H/1 * * * *')
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/bilonjea/cargo-tms.git')
                        // credentials('gh-pat') // Décommente si privé
                    }
                    branch('main')
                }
            }
            scriptPath('Jenkinsfile') // Le Jenkinsfile doit être à la racine du repo
        }
    }
}