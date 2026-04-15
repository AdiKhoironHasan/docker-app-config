.PHONY: help up down restart logs status shell test clean

COMPOSE := docker compose
CONTAINER := mq-rabbitmq

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

up: ## Start RabbitMQ
	$(COMPOSE) up -d --wait
	@echo "✅ RabbitMQ is ready"
	@echo "📊 Management UI: http://localhost:15672 (guest/guest)"

down: ## Stop and remove container
	$(COMPOSE) down

restart: down up ## Restart RabbitMQ

logs: ## Tail container logs
	$(COMPOSE) logs -f

status: ## Show container status
	$(COMPOSE) ps

shell: ## Open a shell inside the container
	docker exec -it $(CONTAINER) sh

test: ## Run a connectivity test
	@echo "🔍 Testing RabbitMQ connectivity..."
	@docker exec $(CONTAINER) rabbitmq-diagnostics -q check_port_connectivity
	@docker exec $(CONTAINER) rabbitmqctl list_queues
	@echo "✅ RabbitMQ is healthy"

clean: ## Stop and remove all volumes (⚠️  destroys data)
	$(COMPOSE) down -v
	@echo "🗑️  All data removed"
