---
layout: post
title: Setup My Ubuntu VPS
date: 2021-01-01
tags: develoment, ubuntu
---

Here’s a polished and complete version of your README article in clear, professional English. I kept your structure but improved wording, added missing context, and made it more readable and practical.

---

# 🚀 Setup My Ubuntu VPS

This guide walks through the basic setup of a fresh Ubuntu VPS, including system updates, essential tools, and Docker installation.

---

## 📦 Update and Upgrade System

Before installing anything, make sure your system packages are up to date.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🧰 Install Common Utilities

Install commonly used tools that are useful for development and server management.

```bash
sudo apt install -y curl wget zip unzip make git gpg
```

---

## 🐳 Install Docker Engine

Follow the steps below to install the latest version of Docker from the official repository.

### 1. Remove Old Docker Versions (if any)

```bash
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
```

---

### 2. Add Docker’s Official GPG Key

```bash
sudo apt update
sudo apt install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
```

---

### 3. Add Docker Repository

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

---

### 4. Install Docker Packages

```bash
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

### 5. Verify Docker Installation

```bash
sudo docker run hello-world
```

If Docker is installed correctly, you will see a confirmation message.

---

### 6. Run Docker Without `sudo` (Optional)

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

> ⚠️ Log out and log back in (or run `newgrp docker`) for the changes to take effect.

---

### 7. Enable Docker on Boot

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

---

## ✅ Final Notes

* Always keep your system updated regularly.
* Use a firewall like `ufw` for better security.
* Consider setting up SSH key authentication instead of password login.
