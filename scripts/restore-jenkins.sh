#!/usr/bin/env bash
set -euo pipefail

VOLUME_NAME="${VOLUME_NAME:-jenkins-data}"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"
BACKUP_PATH="${1:-}"

if [[ -z "$BACKUP_PATH" || ! -f "$BACKUP_PATH" ]]; then
  echo "Usage: $0 <chemin/vers/jenkins_home_backup_YYYY-MM-DD_HHMMSS.tgz>"
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  echo "❌ Docker Compose introuvable."
  exit 1
fi

echo "⏹ Arrêt de la stack…"
$DC -f "$COMPOSE_FILE" down || true

echo "🧱 (Re)création du volume '$VOLUME_NAME'…"
docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1 || docker volume create "$VOLUME_NAME" >/dev/null

echo "📦 Restauration depuis $BACKUP_PATH → volume $VOLUME_NAME"
docker run --rm \
  -v "$VOLUME_NAME":/data \
  -v "$(pwd)":/backup \
  alpine sh -lc "cd /data && tar xzf /backup/'$BACKUP_PATH'"

echo "🚀 Démarrage…"
$DC -f "$COMPOSE_FILE" up -d

echo "✅ Restauration terminée."
$DC -f "$COMPOSE_FILE" ps
