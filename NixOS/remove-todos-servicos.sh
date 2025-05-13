#!/usr/bin/env bash

set -euo pipefail

# Serviço que queremos preservar
PRESERVE="getty@tty1.service"

echo "⛔ Parando todos os serviços (exceto $PRESERVE)..."
systemctl list-units --type=service --no-legend | awk '{print $1}' | while read -r svc; do
    [[ "$svc" == "$PRESERVE" ]] && continue
    systemctl stop "$svc" 2>/dev/null || true
done

echo "🔒 Desabilitando e mascarando todos os serviços disponíveis (exceto $PRESERVE)..."
systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | while read -r svc; do
    [[ "$svc" == "$PRESERVE" ]] && continue
    systemctl disable "$svc" 2>/dev/null || true
    systemctl mask "$svc" 2>/dev/null || true
done

echo "🧨 Removendo arquivos de unidade fora do nix store (exceto $PRESERVE)..."
find /etc/systemd/system /run/systemd/system /etc/systemd/user /run/systemd/user -type f -name '*.service' ! -name "$PRESERVE" -exec rm -v {} \;

echo "✅ Serviços parados, desabilitados, mascarados e arquivos removidos, exceto $PRESERVE."

# Reload das configurações
systemctl daemon-reexec
systemctl daemon-reload

# Garante que o TTY está funcionando
systemctl unmask "$PRESERVE"
systemctl enable --now "$PRESERVE"
