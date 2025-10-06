# ===== Vars overridables =====
COMPOSE       ?= docker compose         # ou: docker-compose
COMPOSE_FILE  ?= docker-compose.yml
SERVICE       ?= my-jenkins             # nom du service Jenkins dans ton compose
VOLUME_NAME   ?= jenkins-data
BACKUP_DIR    ?= backups
BACKUP        ?=                        # ex: BACKUP=backups/jenkins_home_backup_2025-09-02_120000.tgz

# ===== Phony targets =====
.PHONY: help up down restart ps logs shell backup reset restore clean-volumes

help: ## Affiche cette aide
	@awk 'BEGIN {FS = ":.*##"; printf "\nTargets disponibles:\n\n"} \
	/^[a-zA-Z0-9_-]+:.*##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } \
	END { printf "\nExemples:\n  make up\n  make reset\n  make restore BACKUP=$(BACKUP_DIR)/jenkins_home_backup_YYYY-MM-DD_HHMMSS.tgz\n\n" }' $(MAKEFILE_LIST)

up: ## Build & démarre les services
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build
	$(COMPOSE) -f $(COMPOSE_FILE) ps

down: ## Stoppe les services
	$(COMPOSE) -f $(COMPOSE_FILE) down

restart: ## Redémarre (down -> up)
	$(MAKE) down
	$(MAKE) up

ps: ## Montre l’état des services
	$(COMPOSE) -f $(COMPOSE_FILE) ps

logs: ## Affiche les logs (Ctrl-C pour quitter)
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

shell: ## Ouvre un shell dans le conteneur Jenkins
	-$(COMPOSE) -f $(COMPOSE_FILE) exec $(SERVICE) bash || \
	$(COMPOSE) -f $(COMPOSE_FILE) exec $(SERVICE) sh

backup: ## Crée un backup du volume $(VOLUME_NAME) dans $(BACKUP_DIR)/
	@mkdir -p $(BACKUP_DIR)
	@TS=$$(date +%F_%H%M%S); \
	echo "🔐 Backup $(VOLUME_NAME) → $(BACKUP_DIR)/jenkins_home_backup_$${TS}.tgz"; \
	docker run --rm \
	  -v $(VOLUME_NAME):/data \
	  -v $$PWD:/backup \
	  alpine sh -lc "tar czf /backup/$(BACKUP_DIR)/jenkins_home_backup_$${TS}.tgz -C /data ."; \
	ls -lh $(BACKUP_DIR)/jenkins_home_backup_$${TS}.tgz

reset: ## Sauvegarde + réinitialise Jenkins (Option B) puis rebuild & up
	VOLUME_NAME=$(VOLUME_NAME) BACKUP_DIR=$(BACKUP_DIR) COMPOSE_FILE=$(COMPOSE_FILE) \
	./scripts/reset-jenkins.sh

restore: ## Restaure un backup dans $(VOLUME_NAME) puis up (usage: make restore BACKUP=backups/...)
	@test -n "$(BACKUP)" || (echo "❌ Usage: make restore BACKUP=$(BACKUP_DIR)/jenkins_home_backup_YYYY-MM-DD_HHMMSS.tgz"; exit 1)
	VOLUME_NAME=$(VOLUME_NAME) COMPOSE_FILE=$(COMPOSE_FILE) \
	./scripts/restore-jenkins.sh "$(BACKUP)"

clean-volumes: ## ⚠️ down + suppression de tous les volumes de la stack
	$(COMPOSE) -f $(COMPOSE_FILE) down --volumes
