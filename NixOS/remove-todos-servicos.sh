#!/usr/bin/env bash

set -euo pipefail

# Lista de serviços a preservar (adicione outros aqui se necessário)
SERVICOS_PRESERVADOS=(
    "getty@tty1.service"        # TTY principal
    "systemd-logind.service"    # Gerenciamento de sessão
    "systemd-user-sessions.service" # Permite login
)

# Arquivos temporários
TODOS=$(mktemp)
ATIVOS=$(mktemp)

# Lista arquivos de unidade do tipo .service (ex: getty@.service)
systemctl list-unit-files --type=service --no-pager | awk 'NR>1 && $1 ~ /\.service$/ {print $1}' > "$TODOS"

# Lista serviços ativos atualmente (ex: getty@tty1.service)
systemctl list-units --type=service --no-pager --no-legend | awk '{print $1}' >> "$ATIVOS"

# Junta os dois e remove duplicatas
sort -u "$TODOS" "$ATIVOS" > "$TODOS.tmp"
mv "$TODOS.tmp" "$TODOS"

# Loop principal
while read -r svc; do
    # Preserva os serviços essenciais
    if printf '%s\n' "${SERVICOS_PRESERVADOS[@]}" | grep -qx "$svc"; then
        echo "✅ Preservando serviço essencial: $svc"
        continue
    fi

    echo "⛔ Parando, desabilitando e mascarando: $svc"
    systemctl stop "$svc" 2>/dev/null || true
    systemctl disable "$svc" 2>/dev/null || true
    systemctl mask "$svc" 2>/dev/null || true
done < "$TODOS"

# Limpeza
rm -f "$TODOS" "$ATIVOS"

echo "✅ Todos os serviços não essenciais foram parados, desabilitados e mascarados."
