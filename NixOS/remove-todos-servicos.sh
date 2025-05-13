#!/usr/bin/env bash

set -euo pipefail

# Lista de serviços que NÃO devem ser tocados
IGNORAR=(
  "getty@tty1.service"            # TTY principal
  "systemd-logind.service"        # Gerenciamento de sessão
  "getty.target"                  # Target dos TTYs
)

# Cria arquivo temporário com lista de serviços
SERVICOS=$(mktemp)

# Lista todos os arquivos de unidade do tipo service
systemctl list-unit-files --type=service --no-pager | awk 'NR>1 && $1 ~ /\.service$/ {print $1}' > "$SERVICOS"

# Loop principal
while read -r svc; do
    # Se o serviço estiver na lista de ignorados, pula
    if printf "%s\n" "${IGNORAR[@]}" | grep -q -x "$svc"; then
        echo "✅ Ignorando $svc"
        continue
    fi

    echo "⛔ Parando, desabilitando e mascarando: $svc"

    systemctl stop "$svc" 2>/dev/null || true
    systemctl disable "$svc" 2>/dev/null || true
    systemctl mask "$svc" 2>/dev/null || true
done < "$SERVICOS"

rm -f "$SERVICOS"

# Garante que os serviços essenciais estão habilitados
systemctl unmask getty@tty1.service
systemctl enable getty@tty1.service
systemctl start getty@tty1.service

systemctl unmask systemd-logind.service
systemctl enable systemd-logind.service
systemctl start systemd-logind.service

systemctl enable getty.target

echo "✅ Todos os serviços foram desabilitados, exceto os necessários para manter o TTY funcional."
