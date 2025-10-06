folder('apps') {
  displayName('apps')
}

multibranchPipelineJob('apps/my-monorepo') {
  displayName('my-monorepo (GitHub)')
  branchSources {
    branchSource {
      source {
        github {
          id('my-monorepo-gh')                        // identifiant interne
          repoOwner('ORG_OR_USER')                    // ← à remplacer
          repository('my-monorepo')                   // ← à remplacer
          credentialsId('github-token')               // ← StringCredentials
          apiUri('https://api.github.com')            // GH.com ; pour GH Enterprise, mets l’URL API
          traits {
            gitHubBranchDiscovery { strategyId(3) }   // branches: 1=only MRs, 2=only branches, 3=both
            gitHubPullRequestDiscovery { strategyId(2) } // PR de la même origin
            gitHubForkDiscovery {
              strategyId(2)                           // PR depuis forks
              trust(class: 'org.jenkinsci.plugins.github_branch_source.ForkPullRequestDiscoveryTrait$TrustPermission')
            }
            pruneStaleBranch()
            cleanBeforeCheckout()
          }
        }
      }
    }
  }
  factory {
    workflowBranchProjectFactory {
      scriptPath('Jenkinsfile')                       // le pipeline vit dans le repo
    }
  }
  orphanedItemStrategy {
    discardOldItems { numToKeep(20) }
  }
  triggers {
    periodicFolderTrigger('1d')                       // rescans périodiques (webhooks conseillés aussi)
  }
}
