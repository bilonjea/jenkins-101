multibranchPipelineJob('cargo-tms') {
  branchSources {
    branchSource {
      source {
        github {
          id('gh-cargo')
          repoOwner('bilonjea')
          repository('cargo-tms')
          configuredByUrl(false)
          // Laisse vide si repo public ; sinon mets "github-pat"
          credentialsId('github-pat')
          buildForkPRHead(true)
          buildOriginBranch(true)
          buildOriginPRHead(true)
        }
      }
      strategy {
        defaultBranchPropertyStrategy { props { } }
      }
    }
  }
  factory {
    workflowBranchProjectFactory { scriptPath('Jenkinsfile') }
  }
  orphanedItemStrategy {
    discardOldItems { numToKeep(10) }
  }
  triggers {
    periodicFolderTrigger { interval('1d') } // rescan quotidien
  }
}
