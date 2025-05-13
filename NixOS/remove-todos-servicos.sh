#!/usr/bin/env bash

# Arquivo temporário com a lista de serviços
SERVICOS=$(mktemp)

# Lista todos os .service conhecidos pelo systemd
systemctl list-unit-files --type=service --no-pager | awk 'NR>1 && $1 ~ /\.service$/ {print $1}' > "$SERVICOS"

# Para cada serviço, desabilita, para e mascara
while read -r svc; do
    echo "Processando: $svc"
    
    # Evita travar o systemd em si
    if [[ "$svc" =~ ^systemd-(init|reboot|poweroff|halt|shutdown|exit|sleep|suspend|hibernate|hybrid-sleep)\.service$ ]]; then
        echo "⚠️  Ignorando essencial: $svc"
        continue
    fi

    # Desabilita o serviço
    systemctl disable "$svc" --now 2>/dev/null

    # Máscara para garantir que não inicie nem manualmente
    systemctl mask "$svc" 2>/dev/null

done < "$SERVICOS"

# Limpa
rm -f "$SERVICOS"

echo "✅ Todos os serviços processados."
