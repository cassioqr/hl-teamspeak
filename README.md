# TeamSpeak Server - Homelab

Self-hosted TeamSpeak server focused on:
- low latency
- competitive gaming
- high uptime
- lightweight infrastructure

## Stack

- Ubuntu Server 24.04
- Docker
- Docker Compose
- Host networking

## Features

- Auto restart
- Persistent data
- Minimal overhead
- Optimized for competitive games

## Ports

| Port | Protocol | Purpose |
|------|------|------|
| 9987 | UDP | Voice |
| 10011 | TCP | ServerQuery |
| 30033 | TCP | File Transfer |

## Deployment

```bash
docker compose up -d
```

## Logs

```
docker logs teamspeak
```

## Stop

```
docker compose down
```

## Restart

```
docker compose restart
```

## Backup

```
tar -czf ts-backup.tar.gz data/
```

## Notes

Using:
- Docker host networking
- persistent storage
- automatic restart policy
