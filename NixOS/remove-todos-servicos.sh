#!/usr/bin/env bash

set -euo pipefail

# Cria arquivo temporário com lista de serviços
SERVICOS=$(mktemp)

# Lista todos os arquivos de unidades do tipo service
systemctl list-unit-files --type=service --no-pager | awk 'NR>1 && $1 ~ /\.service$/ {print $1}' > "$SERVICOS"

# Loop principal
while read -r svc; do
    echo "⛔ Parando, desabilitando e mascarando: $svc"

    # Para o serviço (se estiver ativo)
    systemctl stop "$svc" 2>/dev/null || true

    # Desabilita o serviço para não iniciar no boot
    systemctl disable "$svc" 2>/dev/null || true

    # Mascara o serviço (impede qualquer execução)
    systemctl mask "$svc" 2>/dev/null || true
done < "$SERVICOS"

# Limpeza
rm -f "$SERVICOS"

echo "✅ Todos os serviços foram desabilitados e mascarados."
