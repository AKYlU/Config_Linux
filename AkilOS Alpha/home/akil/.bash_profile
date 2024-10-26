# .bash_profile

# Carregar aliases e funções
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Verificar se está no Wayland e na tty1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
   gamescope -e -- steam
fi

# Abrir Firefox na tty2 usando gamescope
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty2" ]; then
    sleep 5  # Atraso de 5 segundos
    gamescope -r 60 -o 0 --force-window -- firefox
fi


