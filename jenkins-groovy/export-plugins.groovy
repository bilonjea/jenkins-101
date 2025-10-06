#!/usr/bin/env groovy

Jenkins.instance.pluginManager.plugins.each {
  println "${it.shortName}:${it.version}"
}
