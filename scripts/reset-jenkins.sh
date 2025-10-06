#!/usr/bin/env bash
set -euo pipefail

# Sauvegarde le volume jenkins-data dans ./backups/
# Stoppe la stack
# Supprime le volume jenkins-data
# Rebuild & relance le compose
# Affiche les logs (Ctrl-C pour quitter)

# ── Paramètres (surcharge possible par variables d'env) ──────────────────────────
VOLUME_NAME="${VOLUME_NAME:-jenkins-data}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"

# Détection docker compose v2/v1
if docker compose version >/dev/null 2>&1; then
  DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  DC="docker-compose"
else
  echo "❌ Docker Compose introuvable. Installe docker compose (v2) ou docker-compose (v1)."
  exit 1
fi

# Vérifs de base
[[ -f "$COMPOSE_FILE" ]] || { echo "❌ Fichier $COMPOSE_FILE introuvable"; exit 1; }
mkdir -p "$BACKUP_DIR"

TS="$(date +%F_%H%M%S)"
BACKUP_FILE="jenkins_home_backup_${TS}.tgz"

echo "🔐 Sauvegarde du volume '$VOLUME_NAME' → $BACKUP_DIR/$BACKUP_FILE"
if docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  # On utilise un conteneur Alpine pour archiver le contenu du volume
  docker run --rm \
    -v "$VOLUME_NAME":/data \
    -v "$(pwd)":/backup \
    alpine sh -lc "tar czf /backup/$BACKUP_DIR/$BACKUP_FILE -C /data ."
  echo "✅ Sauvegarde créée: $BACKUP_DIR/$BACKUP_FILE"
else
  echo "⚠️  Volume '$VOLUME_NAME' introuvable, sauvegarde ignorée."
fi

echo "⏹ Arrêt de la stack…"
$DC -f "$COMPOSE_FILE" down

echo "🗑 Suppression du volume '$VOLUME_NAME'…"
if docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  docker volume rm "$VOLUME_NAME"
else
  echo "ℹ️  Volume déjà absent."
fi

echo "🚀 Rebuild & démarrage…"
$DC -f "$COMPOSE_FILE" up -d --build

echo "📋 Services:"
$DC -f "$COMPOSE_FILE" ps

echo "📜 Logs (Ctrl-C pour quitter)…"
$DC -f "$COMPOSE_FILE" logs -f
