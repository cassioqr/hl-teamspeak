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

## Manual Backup

```bash
tar -czf ts-backup.tar.gz data/
```

## Restore Backup

```bash
tar -xzf ts-backup.tar.gz
```

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

# Monitoring

## Recommended Tools

| Tool | Purpose |
|---|---|
| Uptime Kuma | Uptime monitoring |
| Netdata | Real-time metrics |
| Grafana | Dashboards |
| Prometheus | Metrics collection |

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

- Automated backups
- CI/CD pipeline
- GitHub Actions
- Monitoring stack
- Reverse proxy infrastructure
- Multi-service orchestration
- Infrastructure bootstrap scripts
- Centralized logging

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
| Port Forwarding | Pending |
| Monitoring | Planned |
| Automated Backups | Planned |


