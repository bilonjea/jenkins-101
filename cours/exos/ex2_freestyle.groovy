job('cargo-tms-freestyle') {
    displayName('Cargo TMS Freestyle')
    description('Job freestyle pour build contracts-api')

    scm {
        git('https://github.com/bilonjea/cargo-tms.git', 'main')
    }

    steps {
        shell('''
            echo "La variable BUILD_NUMBER vaut : $BUILD_NUMBER"
            cd contracts-api/
            mvn compile
        ''')
    }
}