folder('apps') { displayName('apps') }

multibranchPipelineJob('apps/my-monorepo-gitlab') {
  displayName('my-monorepo (GitLab)')
  branchSources {
    branchSource {
      source {
        gitLabSCMSource {
          id('my-monorepo-gl')
          serverName('GitLab')                        // nom du serveur déclaré côté Jenkins (Manage Jenkins > Configure System)
          projectOwner('GROUP_OR_USER')               // ← à remplacer
          project('my-monorepo')                      // ← à remplacer
          credentialsId('gitlab-token')               // ← StringCredentials (PAT)
          traits {
            gitLabBranchDiscovery { strategyId(3) }
            gitLabMergeRequestDiscovery { strategyId(2) }
            pruneStaleBranch()
            cleanBeforeCheckout()
          }
        }
      }
    }
  }
  factory { workflowBranchProjectFactory { scriptPath('Jenkinsfile') } }
  orphanedItemStrategy { discardOldItems { numToKeep(20) } }
  triggers { periodicFolderTrigger('1d') }
}
