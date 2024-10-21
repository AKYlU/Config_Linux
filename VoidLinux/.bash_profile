# .bash_profile

# Carregar aliases e funções
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Verificar se está no Wayland e na tty1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
   dbus-launch gamescope --fsr --prefer-vk -r 120 -o 0 -e -- flatpak run --nofilesystem=home com.valvesoftware.Steam
fi

# Abrir Firefox na tty2 usando gamescope
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty2" ]; then
    sleep 5  # Atraso de 5 segundos
    gamescope -r 60 -o 0 firefox
fi


