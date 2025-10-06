#!/usr/bin/env groovy

def ids = ['job-dsl','matrix-auth','git'] // derniers disponibles
def uc = Jenkins.instance.updateCenter
ids.each { id ->
  def p = uc.getPlugin(id)
  if (p) { p.deploy().get() }
}
