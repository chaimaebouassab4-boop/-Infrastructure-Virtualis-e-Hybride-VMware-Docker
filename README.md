# 🚀 Infrastructure Virtualisée Hybride : VMware + Docker

[![Project Status](https://img.shields.io/badge/Status-En%20D%C3%A9veloppement-yellow)](https://github.com)
[![VMware](https://img.shields.io/badge/VMware-ESXi%207.0-607078?logo=vmware)](https://www.vmware.com)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-Academic%20Project-blue)](LICENSE)

## 📋 Vue d'ensemble

Déploiement complet d'une **infrastructure virtualisée hybride** combinant machines virtuelles VMware et conteneurs Docker pour moderniser l'architecture d'une startup technologique. Ce projet démontre l'intégration de technologies de virtualisation traditionnelle et de conteneurisation moderne pour améliorer la scalabilité, la résilience et l'efficacité opérationnelle.

**Contexte :** Migration d'infrastructure physique vers architecture cloud-native  
**Durée :** 4 semaines (Jan-Mai 2025)  
**Client fictif :** Startup TechNova  
**Date de présentation :** 14 Mai 2025 à 9h

---

## 🎯 Objectifs du projet

### 🏢 Scénario client : Startup TechNova

La startup TechNova dispose de **2 serveurs physiques** et souhaite héberger :

#### Applications déployées
| Application | Type | Technologie | Utilisateurs cibles |
|-------------|------|-------------|---------------------|
| **Site WordPress** | CMS | WordPress 6.x + MySQL 8.0 | 1000+ simultanés |
| **API REST** | Backend | Node.js 18.x + MongoDB 6.x | Applications mobiles |
| **Serveur de fichiers** | Storage | Windows Server 2019 | Équipes internes |

#### Contraintes techniques
- ✅ Toutes les applications doivent être accessibles via **HTTPS** (SSL/TLS)
- ✅ Infrastructure supportant **1000+ utilisateurs simultanés**
- ✅ **Sauvegardes automatisées** quotidiennes
- ✅ **Monitoring en temps réel** des ressources
- ✅ **Haute disponibilité** (99.5% uptime minimum)

---

## 🏗️ Architecture globale

### Vue d'ensemble de l'infrastructure

```
┌─────────────────────────────────────────────────────────────────────┐
│                        VMware ESXi Host                             │
│                    (32GB RAM, 8 Cores, 500GB SSD)                   │
│                                                                     │
│  ┌──────────────────────────────┐  ┌──────────────────────────┐  │
│  │   Ubuntu Server 22.04 VM     │  │  Windows Server 2019 VM   │  │
│  │   (Docker Host)              │  │  (File Server)            │  │
│  │   8GB RAM | 4 vCPUs          │  │  8GB RAM | 2 vCPUs        │  │
│  │   IP: 192.168.20.10          │  │  IP: 192.168.20.30        │  │
│  │                              │  │                          │  │
│  │  ┌────────────────────────┐  │  │  ┌────────────────────┐ │  │
│  │  │  WordPress Container   │  │  │  │  SMB File Share    │ │  │
│  │  │  Port: 8080            │  │  │  │  Port: 445         │ │  │
│  │  └────────────────────────┘  │  │  └────────────────────┘ │  │
│  │                              │  │                          │  │
│  │  ┌────────────────────────┐  │  │  ┌────────────────────┐ │  │
│  │  │  MySQL Container       │  │  │  │  Backup Storage    │ │  │
│  │  │  Port: 3306            │  │  │  │  500GB Volume      │ │  │
│  │  └────────────────────────┘  │  │  └────────────────────┘ │  │
│  │                              │  └──────────────────────────┘  │
│  │  ┌────────────────────────┐  │                                │
│  │  │  Node.js API Container │  │  ┌──────────────────────────┐  │
│  │  │  Port: 3000            │  │  │  Monitoring VM           │  │
│  │  └────────────────────────┘  │  │  (Ubuntu 22.04)          │  │
│  │                              │  │  4GB RAM | 2 vCPUs       │  │
│  │  ┌────────────────────────┐  │  │  IP: 192.168.10.20       │  │
│  │  │  MongoDB Container     │  │  │                          │  │
│  │  │  Port: 27017           │  │  │  ┌────────────────────┐ │  │
│  │  └────────────────────────┘  │  │  │  Prometheus        │ │  │
│  │                              │  │  │  Port: 9090        │ │  │
│  │  ┌────────────────────────┐  │  │  └────────────────────┘ │  │
│  │  │  Nginx Reverse Proxy   │  │  │                          │  │
│  │  │  Ports: 80, 443        │  │  │  ┌────────────────────┐ │  │
│  │  │  SSL Termination       │  │  │  │  Grafana           │ │  │
│  │  └────────────────────────┘  │  │  │  Port: 3001        │ │  │
│  └──────────────────────────────┘  │  └────────────────────┘ │  │
│                                    └──────────────────────────┘  │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │                vSwitch (Virtual Network)                      │ │
│  │  VLAN 10: Management    192.168.10.0/24                       │ │
│  │  VLAN 20: Production    192.168.20.0/24                       │ │
│  │  VLAN 30: Storage       192.168.30.0/24                       │ │
│  └───────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                              ▼
                    ┌──────────────────┐
                    │  Internet        │
                    │  (Public Access) │
                    └──────────────────┘
```

### 🌐 Segmentation réseau (VLAN)

| VLAN ID | Nom | Subnet | Usage | Accès |
|---------|-----|--------|-------|-------|
| **VLAN 10** | Management | 192.168.10.0/24 | Administration (SSH, vCenter) | Restreint |
| **VLAN 20** | Production | 192.168.20.0/24 | Applications utilisateurs | Public (HTTPS) |
| **VLAN 30** | Storage | 192.168.30.0/24 | Backups, NAS, fichiers | Interne |

### 🔀 Flux de trafic

```
Internet (HTTPS) 
    ↓
Nginx Reverse Proxy (192.168.20.10:443)
    ↓
  ├─→ WordPress (192.168.20.10:8080) ──→ MySQL (192.168.20.10:3306)
  └─→ Node.js API (192.168.20.10:3000) ──→ MongoDB (192.168.20.10:27017)
```

---

## 🛠️ Stack technologique complète

### 🔷 Virtualisation (Couche infrastructure)

| Composant | Version | Rôle |
|-----------|---------|------|
| **VMware ESXi** | 7.0 U3 | Hyperviseur bare-metal |
| **vSphere Client** | 7.0 | Interface de gestion VMs |
| **vCenter Server** | 7.0 | Gestion centralisée (optionnel) |
| **vSwitch** | Standard | Réseau virtuel + VLAN |

### 🐳 Conteneurisation (Couche applications)

| Composant | Version | Utilisation |
|-----------|---------|-------------|
| **Docker Engine** | 24.0.7 | Runtime de conteneurs |
| **Docker Compose** | v2.23 | Orchestration multi-conteneurs |
| **Docker Hub** | - | Registry d'images publiques |

### 🌐 Applications & Services

#### Frontend & Backend
| Application | Image Docker | Port | Volumétrie |
|-------------|--------------|------|-----------|
| **WordPress** | `wordpress:6.4-php8.2-apache` | 8080 | 5GB persistent |
| **MySQL** | `mysql:8.0` | 3306 | 10GB persistent |
| **Node.js API** | `node:18-alpine` (custom) | 3000 | 2GB persistent |
| **MongoDB** | `mongo:6.0` | 27017 | 15GB persistent |
| **Nginx** | `nginx:1.25-alpine` | 80, 443 | 1GB logs |

#### Monitoring & Observabilité
| Outil | Image Docker | Port | Dashboard |
|-------|--------------|------|-----------|
| **Prometheus** | `prom/prometheus:v2.48` | 9090 | Métriques brutes |
| **Grafana** | `grafana/grafana:10.2` | 3001 | Visualisations |
| **cAdvisor** | `gcr.io/cadvisor/cadvisor:latest` | 8081 | Métriques Docker |
| **Node Exporter** | `prom/node-exporter:v1.7` | 9100 | Métriques système |

### 🔒 Sécurité & Certificats

| Composant | Usage |
|-----------|-------|
| **UFW** (Uncomplicated Firewall) | Pare-feu Ubuntu |
| **Certbot** | Certificats SSL Let's Encrypt |
| **Docker Security Scanning** | Vulnérabilités images |
| **VMware vSphere Hardening** | Sécurisation hyperviseur |

---

## 📅 Planning de développement (4 semaines)

### 📆 Semaine 1 : Planification & Installation
**Dates :** 15-21 Janvier 2025  
**Statut :** ✅ **Complété**

#### Tâches réalisées
- [x] Analyse des besoins de la startup TechNova
- [x] Conception du schéma d'architecture réseau
- [x] Installation de VMware ESXi 7.0 sur serveur physique
- [x] Création de 3 VMs :
  - Ubuntu Server 22.04 (Docker Host) - 8GB RAM, 4 vCPUs
  - Windows Server 2019 (File Server) - 8GB RAM, 2 vCPUs
  - Ubuntu Server 22.04 (Monitoring) - 4GB RAM, 2 vCPUs
- [x] Configuration vSwitch avec 3 VLANs (10, 20, 30)
- [x] Tests de connectivité (ping entre VMs, accès SSH)

#### Livrables produits
- ✅ Schéma d'architecture validé (architecture-diagram.png)
- ✅ VMs opérationnelles avec connectivité réseau
- ✅ Documentation de configuration VMware

#### Commandes clés exécutées
```bash
# Création vSwitch sur ESXi
esxcli network vswitch standard add --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup add --portgroup-name=VLAN10-Management --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup set --portgroup-name=VLAN10-Management --vlan-id=10

# Test de connectivité
ping -c 4 192.168.20.10  # Ubuntu Docker Host
ssh root@192.168.10.20   # Monitoring VM
```

---

### 📆 Semaine 2 : Déploiement Docker & Applications
**Dates :** 22-28 Janvier 2025  
**Statut :** 🟡 **En cours (75% complété)**

#### Tâches en cours
- [x] Installation Docker Engine 24.0.7 sur Ubuntu VM
- [x] Installation Docker Compose v2.23
- [x] Création Dockerfile WordPress personnalisé
- [x] Configuration docker-compose.yml pour WordPress + MySQL
- [ ] Développement API Node.js (Express + MongoDB)
- [ ] Configuration réseau Docker (bridge network)
- [ ] Tests d'accessibilité applications

#### Livrables en cours
- ✅ WordPress accessible via http://192.168.20.10:8080
- ✅ MySQL opérationnel (users créés, database initialisée)
- 🟡 Node.js API en développement
- 📅 Fichiers finaux docker-compose.yml

#### Configuration Docker actuelle
```yaml
# docker-compose.yml (WordPress stack)
version: '3.8'

services:
  wordpress:
    image: wordpress:6.4-php8.2-apache
    container_name: technova-wordpress
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql:3306
      WORDPRESS_DB_NAME: wordpress_db
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: SecurePass123!
    volumes:
      - wordpress_data:/var/www/html
    networks:
      - app_network
    restart: always

  mysql:
    image: mysql:8.0
    container_name: technova-mysql
    environment:
      MYSQL_ROOT_PASSWORD: RootPass456!
      MYSQL_DATABASE: wordpress_db
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: SecurePass123!
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app_network
    restart: always

volumes:
  wordpress_data:
  mysql_data:

networks:
  app_network:
    driver: bridge
```

---

### 📆 Semaine 3 : Monitoring & Sécurité
**Dates :** 29 Janvier - 4 Février 2025  
**Statut :** 📅 **À venir**

#### Tâches planifiées
- [ ] Installation Prometheus sur VM Monitoring
- [ ] Configuration Grafana avec datasource Prometheus
- [ ] Création dashboards Grafana :
  - Dashboard 1 : Métriques Docker (CPU, RAM, réseau par conteneur)
  - Dashboard 2 : Ressources VMware (VMs, vCPUs, storage)
  - Dashboard 3 : Performance applicative (temps de réponse HTTP)
- [ ] Configuration snapshots VMware automatisés (cron daily)
- [ ] Backups volumes Docker avec scripts bash
- [ ] Configuration pare-feu UFW sur Ubuntu VM
- [ ] Installation Certbot + génération certificats SSL
- [ ] Configuration Nginx reverse proxy avec SSL termination

#### Livrables attendus
- 📊 Dashboard Grafana opérationnel avec métriques en temps réel
- 🔒 Certificats SSL Let's Encrypt installés
- 💾 Procédure de backup/restore documentée
- 🛡️ Pare-feu configuré avec règles restrictives

#### Scripts de monitoring prévus
```bash
# prometheus.yml (configuration collecte métriques)
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'docker-containers'
    static_configs:
      - targets: ['192.168.20.10:8081']  # cAdvisor

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['192.168.20.10:9100']  # Système Ubuntu
```

---

### 📆 Semaine 4 : Tests & Optimisation
**Dates :** 5-14 Mai 2025  
**Statut :** 📅 **À venir**

#### Tâches planifiées
- [ ] Tests de charge avec Apache JMeter (1000 users simultanés)
- [ ] Analyse des résultats (temps de réponse, erreurs, throughput)
- [ ] Optimisation ressources :
  - Ajustement limites CPU/RAM Docker
  - Allocation dynamique vCPUs VMware
  - Tuning MySQL (buffer pools, query cache)
- [ ] Tests de résilience :
  - Redémarrage brutal d'un conteneur
  - Panne d'une VM
  - Saturation disque
- [ ] Rédaction rapport technique final (20+ pages)
- [ ] Création présentation PowerPoint (15 slides)
- [ ] Enregistrement vidéo de démonstration (5-10 min)

#### Livrables finaux
- 📄 Rapport technique complet (PDF, 20-30 pages)
- 🎥 Vidéo de démonstration (déploiement + tests)
- 📊 Résultats tests de performance (graphiques JMeter)
- 📑 Présentation orale (PowerPoint + démo live)

#### Tests de charge prévus
```bash
# Plan de test JMeter
Thread Group: 1000 utilisateurs
Ramp-up: 60 secondes
Loop Count: 100 requêtes par user

Scénarios:
1. GET / (page d'accueil WordPress)
2. POST /api/v1/data (API Node.js)
3. GET /api/v1/users (API Node.js)

Assertions:
- Response time < 200ms (95th percentile)
- Error rate < 1%
- Throughput > 500 req/sec
```

---

## 🚀 Guide de déploiement rapide

### Prérequis matériels

#### Serveur physique minimum
```
CPU     : Intel Xeon / AMD EPYC (8+ cores avec virtualisation VT-x/AMD-V)
RAM     : 32 GB DDR4 ECC (minimum)
Storage : 500 GB SSD NVMe (ou 1TB SATA SSD)
Network : 2x 1Gbps Ethernet (bonding recommandé)
BIOS    : Virtualisation activée (Intel VT-x / AMD-V)
```

#### Logiciels requis
- VMware ESXi 7.0 U3 (ISO téléchargeable gratuitement)
- vSphere Client 7.0 (interface web)
- Poste client avec navigateur moderne (Chrome/Firefox)

---

### 🔧 Installation pas-à-pas

#### 1️⃣ Installation VMware ESXi

```bash
# 1. Télécharger ESXi 7.0 ISO depuis vmware.com
# 2. Créer USB bootable avec Rufus ou Etcher
# 3. Booter sur le serveur physique
# 4. Suivre l'assistant d'installation graphique
# 5. Configurer IP management (ex: 192.168.10.5)

# Connexion SSH à ESXi (après installation)
ssh root@192.168.10.5

# Vérification version
vmware -v
# Output: VMware ESXi 7.0.3 build-xxxxx
```

#### 2️⃣ Configuration réseau virtuel (vSwitch + VLANs)

```bash
# Connexion ESXi via SSH
ssh root@192.168.10.5

# Création vSwitch principal
esxcli network vswitch standard add --vswitch-name=vSwitch1

# Ajout des port groups avec VLANs
esxcli network vswitch standard portgroup add \
  --portgroup-name=VLAN10-Management \
  --vswitch-name=vSwitch1

esxcli network vswitch standard portgroup set \
  --portgroup-name=VLAN10-Management \
  --vlan-id=10

# Répéter pour VLAN 20 (Production) et VLAN 30 (Storage)
esxcli network vswitch standard portgroup add \
  --portgroup-name=VLAN20-Production \
  --vswitch-name=vSwitch1

esxcli network vswitch standard portgroup set \
  --portgroup-name=VLAN20-Production \
  --vlan-id=20

# Vérification configuration
esxcli network vswitch standard list
```

#### 3️⃣ Création des machines virtuelles

**Via vSphere Client (Interface Web):**

1. Connexion : https://192.168.10.5/ui
2. Clic droit sur host → "Create/Register VM"
3. Configuration pour chaque VM :

**Ubuntu Docker Host :**
```yaml
Name: technova-docker-host
Guest OS: Ubuntu Linux (64-bit)
CPUs: 4 vCPUs
RAM: 8192 MB
Disk: 100 GB (Thin Provisioned)
Network: VLAN20-Production
ISO: ubuntu-22.04.3-live-server-amd64.iso
```

**Windows File Server :**
```yaml
Name: technova-file-server
Guest OS: Windows Server 2019 (64-bit)
CPUs: 2 vCPUs
RAM: 8192 MB
Disk: 150 GB (Thick Provisioned)
Network: VLAN20-Production
ISO: windows-server-2019.iso
```

**Ubuntu Monitoring :**
```yaml
Name: technova-monitoring
Guest OS: Ubuntu Linux (64-bit)
CPUs: 2 vCPUs
RAM: 4096 MB
Disk: 50 GB (Thin Provisioned)
Network: VLAN10-Management
ISO: ubuntu-22.04.3-live-server-amd64.iso
```

#### 4️⃣ Installation Docker sur Ubuntu VM

```bash
# Connexion SSH à la VM Ubuntu
ssh user@192.168.20.10

# Mise à jour système
sudo apt update && sudo apt upgrade -y

# Installation dépendances
sudo apt install -y ca-certificates curl gnupg lsb-release

# Ajout du dépôt officiel Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation Docker Engine + Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ajout utilisateur au groupe docker (éviter sudo)
sudo usermod -aG docker $USER
newgrp docker

# Vérification installation
docker --version
# Output: Docker version 24.0.7, build afdd53b

docker compose version
# Output: Docker Compose version v2.23.3
```

#### 5️⃣ Déploiement WordPress + MySQL

```bash
# Création dossier projet
mkdir -p ~/technova-infrastructure/docker/wordpress
cd ~/technova-infrastructure/docker/wordpress

# Création fichier docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  wordpress:
    image: wordpress:6.4-php8.2-apache
    container_name: technova-wordpress
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql:3306
