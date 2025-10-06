#!/usr/bin/env bash

set -euo pipefail
# Exporte les plugins Jenkins installés dans un fichier plugins.txt

curl -s -u admin:password \
  'http://localhost:8080/pluginManager/api/json?depth=1' \
  | jq -r '.plugins[] | "\(.shortName):\(.version)"' \
  | sort > plugins.lock.txt
echo "Plugins exportés dans plugins.lock.txt"