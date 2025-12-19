multibranchPipelineJob("cargo-tms-multibranch-with-github") {
    displayName("Cargo TMS Multibranch Pipeline with github")
    description("Multibranch pipeline for cargo-tms repository with github")

    branchSources {
        branchSource {
            source {
                github {
                    repoOwner("bilonjea")
                    repository("cargo-tms")
                    repositoryUrl("https://github.com/bilonjea/cargo-tms.git")
                    configuredByUrl(true)
                    traits {
                        gitHubBranchDiscovery {
                            strategyId(1) // Découvre toutes les branches
                        }
                        /*
                        cleanBeforeCheckoutTrait()
                        cleanAfterCheckoutTrait()
                         */

                        cloneOptionTrait {
                            extension {
                                //$class: 'jenkins.plugins.git.traits.CloneOptionTrait'
                                shallow(true)
                                depth(1)
                                timeout(10)
                                noTags(true)
                                reference('')
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
