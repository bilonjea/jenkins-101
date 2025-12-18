multibranchPipelineJob("cargo-tms") {
    displayName("Cargo TMS Pipeline")
    description("Multibranch pipeline for cargo-tms repository")

    branchSources {
        branchSource {
            source {
                github {
                    id('gh-cargo')
                    repositoryUrl('https://github.com/bilonjea/cargo-tms')
                    configuredByUrl(true)
                    // credentialsId('gh-pat') // Décommentez si privé
                    traits {
                        gitHubBranchDiscovery { strategyId(1) }
                        cleanBeforeCheckoutTrait()
                        cleanAfterCheckoutTrait()
                        cloneOptionTrait {
                            extension {
                                shallow(true)
                                depth(1)
                                timeout(10)
                                noTags(true)
                            }
                        }
                    }
                }
            }
        }
    }

    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile')
        }
    }

    orphanedItemStrategy {
        discardOldItems {
            numToKeep(10)
            daysToKeep(-1)
        }
    }

    triggers {
        periodicFolderTrigger {
            interval('2m') // Scan toutes les 2 minutes
        }
    }
}