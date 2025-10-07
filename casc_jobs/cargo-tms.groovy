multibranchPipelineJob("cargo-tms") {
    displayName("Cargo TMS Pipeline")
    description("Multibranch pipeline for cargo-tms repository")
    
    branchSources {
        branchSource {
            source {
                github {
                    id('gh-cargo')  // ID unique pour cette source
                    repositoryUrl('https://github.com/bilonjea/cargo-tms')
                    configuredByUrl(true)
                    // credentialsId('gh-pat') // Décommentez si dépôt privé
                    traits {
                        gitHubBranchDiscovery {
                            strategyId(1) // Découvre seulement les branches
                        }
                        gitHubPullRequestDiscovery {
                            strategyId(1) // Découvre les PR depuis la branche source
                        }
                        gitHubForkDiscovery {
                            strategyId(1) // Découvre les PR depuis les forks
                            trust('Permission')
                        }
                        cleanBeforeCheckoutTrait() // Nettoie le workspace avant checkout
                        cleanAfterCheckoutTrait() // Nettoie après checkout
                        cloneOptionTrait {
                            extension {
                                shallow(true) // Clone shallow pour plus de rapidité
                                depth(1)
                                timeout(10)
                                noTags(true)
                            }
                        }
                    }
                }
            }
            strategy {
                defaultBranchPropertyStrategy {
                    props {
                        // Pas de propriétés supplémentaires pour l'instant
                    }
                }
            }
        }
    }
    
    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile') // Chemin vers le Jenkinsfile dans le repo
        }
    }
    
    orphanedItemStrategy {
        discardOldItems {
            numToKeep(10) // Garde les 10 dernières builds
            daysToKeep(-1) // Pas de limite en jours
        }
    }
    
    triggers {
        periodicFolderTrigger {
            interval('1d') // Scan quotidien du repository
        }
    }
    
    properties {
        folderCredentialsProperty {
            domainCredentials {
                domainCredentials {
                    domain {
                        name('')
                        description('')
                    }
                    credentials {
                        // Ajoutez ici les credentials si nécessaires
                    }
                }
            }
        }
    }
    
    configure { project ->
        project / 'sources' / 'data' / 'jenkins.branch.BranchSource' / 'source' / 'traits' {
            'jenkins.scm.impl.trait.WildcardSCMHeadFilterTrait' {
                includes('*') // Inclut toutes les branches
                excludes('')  // N'exclut aucune branche
            }
        }
    }
}