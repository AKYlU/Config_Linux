#!/usr/bin/env bash

set -euo pipefail

echo "⛔ Parando todos os serviços..."
systemctl list-units --type=service --no-legend | awk '{print $1}' | while read -r svc; do
    systemctl stop "$svc" 2>/dev/null || true
done

echo "🔒 Desabilitando e mascarando todos os serviços disponíveis..."
systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | while read -r svc; do
    systemctl disable "$svc" 2>/dev/null || true
    systemctl mask "$svc" 2>/dev/null || true
done

echo "🧨 Removendo arquivos de unidade fora do nix store..."
find /etc/systemd/system /run/systemd/system /etc/systemd/user /run/systemd/user -type f -name '*.service' -exec rm -v {} \;

echo "✅ Serviços parados, desabilitados, mascarados e arquivos removidos onde possível."

# Reload das configurações
systemctl daemon-reexec
systemctl daemon-reload
