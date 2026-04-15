# RabbitMQ

## About

A single-instance RabbitMQ message broker with the **Management plugin** enabled, using the **Alpine-based** image for minimal footprint (~80MB). Includes a web-based management UI for monitoring queues, exchanges, and connections.

## Spec

| Property | Value |
|----------|-------|
| Image | `rabbitmq:4-management-alpine` |
| Architecture | Single instance |
| Memory Limit | 512MB |
| Management UI | Enabled |
| Default Vhost | `/` |
| Healthcheck | `rabbitmq-diagnostics check_port_connectivity` |

### Ports

| Host Port | Container Port | Protocol | Description |
|-----------|----------------|----------|-------------|
| 5672 | 5672 | AMQP | Message broker |
| 15672 | 15672 | HTTP | Management UI |

## How to Run

```bash
# Start RabbitMQ
make up

# Or manually
docker compose up -d
```

## How to Test

### Management UI

Open in your browser: **http://localhost:15672**

Login with `guest` / `guest`.

### Connect via rabbitmqctl

```bash
# Open a shell inside the container
make shell

# Check node status
docker exec -it message-queue-rabbitmq rabbitmqctl status

# List queues
docker exec -it message-queue-rabbitmq rabbitmqctl list_queues

# List exchanges
docker exec -it message-queue-rabbitmq rabbitmqctl list_exchanges

# List connections
docker exec -it message-queue-rabbitmq rabbitmqctl list_connections
```

### Quick connectivity test

```bash
make test

# Or manually
docker exec message-queue-rabbitmq rabbitmq-diagnostics -q check_port_connectivity
```

### Publish and consume a test message (via Management API)

```bash
# Declare a test queue
curl -u guest:guest -X PUT http://localhost:15672/api/queues/%2F/test-queue \
  -H "content-type: application/json" \
  -d '{"durable": false}'

# Publish a message
curl -u guest:guest -X POST http://localhost:15672/api/exchanges/%2F/amq.default/publish \
  -H "content-type: application/json" \
  -d '{"properties":{},"routing_key":"test-queue","payload":"Hello RabbitMQ!","payload_encoding":"string"}'

# Consume the message
curl -u guest:guest -X POST http://localhost:15672/api/queues/%2F/test-queue/get \
  -H "content-type: application/json" \
  -d '{"count":1,"ackmode":"ack_requeue_false","encoding":"auto"}'
```

### Connection String (AMQP)

```
amqp://guest:guest@localhost:5672/
```

## Default Credentials

| User | Password | Vhost | Tags |
|------|----------|-------|------|
| guest | guest | / | administrator |

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `RABBITMQ_DEFAULT_USER` | guest | Default username |
| `RABBITMQ_DEFAULT_PASS` | guest | Default password |
| `RABBITMQ_DEFAULT_VHOST` | / | Default virtual host |

## Make Targets

| Target | Description |
|--------|-------------|
| `make up` | Start RabbitMQ |
| `make down` | Stop and remove container |
| `make restart` | Restart RabbitMQ |
| `make logs` | Tail container logs |
| `make status` | Show container status |
| `make shell` | Open a shell inside the container |
| `make test` | Run a connectivity test |
| `make clean` | Stop and remove all volumes |
