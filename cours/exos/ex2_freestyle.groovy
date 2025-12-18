job('cargo-tms-freestyle') {
    displayName('Cargo TMS Freestyle')
    description('Job freestyle pour build contracts-api')

    // Supprime le workspace avant le build
    wrappers {
        preBuildCleanup()
    }

    // Clone du repo public
    scm {
        git('https://github.com/bilonjea/cargo-tms.git', 'main')
    }

    // Build contracts-api
    steps {
        shell('''
            echo "La variable BUILD_NUMBER vaut : $BUILD_NUMBER"
            cd contracts-api/
            mvn clean install
        ''')
    }

    // Archive le jar généré
    publishers {
        archiveArtifacts {
            pattern('contracts-api/target/*.jar')
        }
    }
}