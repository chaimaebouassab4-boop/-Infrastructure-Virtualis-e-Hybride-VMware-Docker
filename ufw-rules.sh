#!/bin/bash
# Sécurisation du serveur avec UFW (Uncomplicated Firewall)
# [cite_start]Basé sur le rapport page 40 [cite: 1799, 1800]

# 1. Mise à jour des dépôts
sudo apt update

# 2. Installation de UFW (si non installé)
sudo apt install ufw -y

# 3. Réinitialisation des règles (par sécurité)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 4. Autorisation des ports critiques
echo "Autorisation du port SSH (22)..."
sudo ufw allow 22/tcp

echo "Autorisation du port HTTP (80)..."
sudo ufw allow 80/tcp

echo "Autorisation du port HTTPS (443)..."
sudo ufw allow 443/tcp

# 5. Activation du pare-feu
echo "Activation de UFW..."
sudo ufw enable

# [cite_start]6. Vérification du statut [cite: 1802]
sudo ufw status verbose
