# TeamSpeak Server Infrastructure Documentation

## Overview

Self-hosted TeamSpeak server running in a homelab environment focused on:

- Low latency
- High uptime
- Competitive gaming communication
- Lightweight infrastructure
- Easy recovery and reproducibility

---

# Infrastructure

## Host Information

| Component | Value |
|---|---|
| OS | Ubuntu Server 24.04 LTS |
| Container Runtime | Docker |
| Orchestration | Docker Compose |
| Networking | Host Networking |
| Storage | Persistent bind mount |
| Service Type | Voice Communication |

---

# Architecture

```text
Internet
   |
Router (UDP 9987 Forward)
   |
Ubuntu Server
   |
Docker Engine
   |
TeamSpeak Container
```

---

# Repository Structure

```text
hl-services/
└── teamspeak/
    ├── docker-compose.yml
    ├── README.md
    ├── backup.sh
    ├── .gitignore
    └── data/
```

---

# Docker Compose Configuration

## docker-compose.yml

```yaml
services:
  teamspeak:
    image: teamspeak:latest

    container_name: teamspeak

    restart: unless-stopped

    network_mode: host

    environment:
      TS3SERVER_LICENSE: accept

    volumes:
      - ./data:/var/ts3server
```

---

# Design Decisions

## Why Docker?

Docker was selected because it provides:

- Easy deployment
- Fast recovery
- Service isolation
- Simple upgrades
- Persistent storage management
- Automatic restart policies
- Minimal operational complexity

### Performance Considerations

The TeamSpeak server uses:

- Host networking
- Native Linux kernel networking stack
- No bridge NAT overhead

This minimizes latency and jitter for competitive gaming.

---

# Networking

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 9987 | UDP | Voice Communication |
| 10011 | TCP | ServerQuery |
| 30033 | TCP | File Transfer |

---

# Firewall / Router

## Required Port Forwarding

Forward the following port to the Ubuntu host:

```text
9987/UDP
```

Optional:

```text
10011/TCP
30033/TCP
```

---

# Persistence

Persistent storage is handled through a bind mount:

```text
./data:/var/ts3server
```

This ensures:

- Server configuration survives container recreation
- Permissions persist
- Channels and users remain intact
- Backups are simple

---

# Service Lifecycle

## Start Service

```bash
docker compose up -d
```

## Stop Service

```bash
docker compose down
```

## Restart Service

```bash
docker compose restart
```

## View Logs

```bash
docker logs teamspeak
```

## View Running Containers

```bash
docker ps
```

---

# Backup Strategy

Backups are created directly from inside the container using Docker commands.

This approach avoids Linux filesystem permission issues caused by container UID/GID mappings and keeps the backup workflow isolated from host-side permission conflicts.

---

## Backup Script

```bash
./backup.sh
```

---

## Backup Features

- Timestamped backups
- Automatic backup directory creation
- Backup generation inside container
- Archive export using `docker cp`
- Automatic cleanup of temporary files
- Backup retention policy
- Automatic deletion of old backups

---

## Backup Workflow

```text
TeamSpeak Container
        |
        | docker exec
        v
Temporary Archive (/tmp)
        |
        | docker cp
        v
Host Backup Directory
```

---

## Backup Location

```text
~/backups/teamspeak
```

---

## Retention Policy

Current retention period:

```text
14 days
```

Older backups are automatically removed by the backup script.

---

## Backup Design Decision

Instead of backing up bind-mounted files directly from the host filesystem, backups are generated from inside the container using Docker tooling.

### Reasons

- Avoid Linux UID/GID permission conflicts
- Maintain container ownership consistency
- Improve portability
- Reduce host filesystem dependency
- Simplify operational workflows
- Prevent permission-related backup failures

---

## Manual Backup

```bash
./backup.sh
```

---

## Restore Procedure

### 1. Stop the container

```bash
docker compose down
```

---

### 2. Extract the backup

```bash
tar -xzf teamspeak_backup_DATE.tar.gz
```

---

### 3. Restore TeamSpeak data

Restore the extracted `ts3server` files into the persistent storage directory.

---

### 4. Start the container

```bash
docker compose up -d
```

---

## Troubleshooting

### Permission Issues During Backup

The TeamSpeak container creates files using its internal UID/GID.

Direct host-side backups may fail due to restricted Linux filesystem permissions.

### Solution

- Create backups from inside the container using `docker exec`
- Export archives using `docker cp`

---

# Security

## Current Security Measures

- Docker isolation
- No GUI installed
- Minimal exposed ports
- Linux host environment

## Recommended Future Improvements

- UFW firewall
- Fail2Ban
- Tailscale administration access
- Automatic backups
- Monitoring stack
- UPS power backup

---

# Performance Optimization

## Low Latency Configuration

The following optimizations are recommended:

### Host Networking

```yaml
network_mode: host
```

Reduces networking overhead and avoids bridge NAT.

---

### Ethernet Only

The server should use:

- Wired Ethernet
- Stable network switch/router
- No Wi-Fi

---

### CPU Governor

Recommended governor:

```text
performance
```

This avoids CPU power-saving latency spikes.

---

### SQM / CAKE

Recommended router QoS:

- CAKE
- FQ_CODEL

Benefits:

- Lower jitter
- Better packet scheduling
- Reduced bufferbloat
- Stable voice communication during downloads/uploads

---

# Troubleshooting

## Container Not Running

Check:

```bash
docker ps -a
```

Inspect logs:

```bash
docker logs teamspeak
```

---

## Port Not Reachable

Verify:

- Router port forwarding
- ISP CGNAT status
- Local firewall rules

---

## High Latency / Voice Lag

Check:

- Bufferbloat
- Wi-Fi usage
- CPU governor
- Internet congestion
- Packet loss

---

# Disaster Recovery

## Recovery Procedure

1. Install Ubuntu Server
2. Install Docker
3. Clone repository
4. Restore backup
5. Run Docker Compose

```bash
docker compose up -d
```

Infrastructure should become operational within minutes.

---

# Future Improvements

## Planned Enhancements

- CI/CD pipeline
- GitHub Actions
- Monitoring stack
- Multi-service orchestration
- Infrastructure bootstrap scripts

---

# Goals

This homelab project aims to:

- Learn infrastructure management
- Practice DevOps concepts
- Build reproducible environments
- Improve Linux administration skills
- Understand self-hosting workflows
- Create production-like home infrastructure

---

# Status

| Component | Status |
|---|---|
| Docker | Operational |
| TeamSpeak | Operational |
| Persistent Storage | Operational |
| Host Networking | Operational |
| Git Versioning | Operational |
| Port Forwarding | Operational |
| Monitoring | Planned |
| Automated Backups | Operational |


