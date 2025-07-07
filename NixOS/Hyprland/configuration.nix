{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;                      # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  time.timeZone = "America/Recife";                   # Define o fuso horário do sistema
  # i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "us";                                 # Define o layout de teclado do console

  networking.networkmanager.enable = true;

  users.users.akil = {                                   # Configuração do usuário 'akyil'
    isNormalUser = true;                                 # Usuário não-root
    uid = 1000;                                          # ID de usuário
    extraGroups = [ "video" ];                           # Grupos adicionais
    shell = pkgs.fish;                                   # Define o shell padrão como Fish
  };

  programs.fish.enable = true;                           # Habilita o Fish como shell interativo

  users.users.root = {
   shell = pkgs.fish;  # Define fish como shell padrão do root
  };

  hardware.pulseaudio.enable = false;                    # Desabilita PulseAudio
  services.pipewire = {                                  # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                  # Suporte ALSA
    # alsa.support32Bit = true;                            # Suporte a bins de 32 bits
    pulse.enable = true;                                  # Habilita compatibilidade PulseAudio
    jack.enable = false;                                  # Habilita compatibilidade JACK
  };

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

   services.getty.autologinUser = "akil";   # Autologin em tty1

#security.polkit.enable = false;

# Ative configurações sysctl persistentes via Nix
boot.kernel.sysctl."vm.swappiness" = 0; # Define o nível de uso da swap

#  services.keyd = {
#    enable = true;
#    keyboards.default = {
#      settings = {
#        main = {
#        m5 = "m4";         # Tecla física 'a' envia 'b'
#        M5 = "M4";         # Tecla física 'b' envia 'a'
#         # capslock = "esc";  # Caps Lock vira Escape
#        };
#      };
#    };
#  };

   hardware.graphics = {              # Configurações de GPU para steam
    enable = true;                   # Habilita drivers gráficos
    enable32Bit = true;   
   };

  fonts = {                          # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
 };

 programs.java = {                  # Configuração do Java
    enable = true;
    package = pkgs.jdk21;            # Define pacote JDK21
   };

  services.avahi.enable = false;         # Desative se não precisar de descoberta de rede local
  services.openssh.enable = false;       # Só ative se realmente for usar acesso remoto
  services.printing.enable = false;      # Desative se não tiver impressora
  # Desativa a espera por rede online no boot
  systemd.network.wait-online.enable = false;

  # Desativa sincronização de horário (útil em desktop offline)
  services.timesyncd.enable = false;

  # Desativa o firewall (se não for necessário)
  networking.firewall.enable = false;

  # Não use X11 nem Display Manager
  services.xserver.enable = false;
  services.displayManager.enable = false;

  services.upower.enable = false;                     # sem gerenciamento de bateria/suspensão  #
  services.accounts-daemon.enable = false;            # remove daemon de gerenciamento de usuários #
  services.geoclue2.enable = false;                   # remove localização baseada em IP        #
  # sound.enable = false;                               # sem ALSA em nível global se pipewire    #
  services.resolved.enable = false;
  networking.useDHCP = false;
hardware.alsa.enable = false;  # desativa ALSA no nível do kernel/usuário

  # força que bluetooth.target nunca seja Wanted
  systemd.services."bluetooth.target".wantedBy = lib.mkForce [];
  # garante que nada fique After=bluetooth.target
  systemd.services."bluetooth.target".after    = lib.mkForce [];

  # Blacklist dos módulos de kernel Bluetooth
  boot.blacklistedKernelModules = [
    "btusb"      # driver USB Bluetooth
    "bluetooth"  # módulo genérico Bluetooth
  ];

services.journald = {
  storage     = "none";   # sem logs em disco
  extraConfig = ''        # caso queira ainda alguma diretiva mínima
    RuntimeMaxUse   = 0   # 0 bytes em RAM
    RuntimeKeepFree = 1M  # sempre 1 MiB livre
  '';
};

  hardware.enableAllFirmware = false;                 # só firmware explicitamente necessário  #
  boot.initrd.kernelModules = [ "amdgpu" ];           # apenas o driver da iGPU Vega           #
  boot.kernelModules = [ ];                           # limpa módulos extras                   #


  environment.systemPackages = with pkgs; [              # Pacotes instalados globalmente

    blender             # Programa de modelagem 3D especializado
    reaper              # DAW para edição de áudio
    openutau            # UTAU

    unityhub            # Hub do Unity Engine
    librewolf           # Firefox

    # TUI
    lunarvim            # Editor de texto (configurado como IDE)
    ranger              # File
    btop-rocm           # Cpu

    hyprshot            # foto
    hyprland
    xwayland
    swww
    wlsunset            # Ajuste de temperatura de cor no Wayland
    grim                # tira foto
    slurp               # seletor
    #ffmpeg              # gravador
    wf-recorder         # gravar video
    qjackctl            # e som tambem mais nao sei para que seve
    # mpvpaper          # wallpepar
    pulseaudio          # Cliente PulseAudio (requerido por alguns apps)
    # qpwgraph            # para manda som da utau
    kitty               # Terminal
    #noto-fonts-cjk-sans # Fontes Noto CJK sans  
    wl-clipboard        # copiar/colar 
    # xclip               # copiar/colar
    # premid              # status
    done
    xdg-utils           # xdg-open
    playerctl           # Controle de player via CLI
    
    steam                            # Plataforma de jogos Steam
    prismlauncher                    # Launcher para jogos Prismatik
    
    jdk21                            # Java Development Kit 21
#    nodejs_23                        # tema unity
    python3
    python3Packages.flask

    atool               # zip
    unzip               # zip
    unrar               # rar
    desktop-file-utils  # mine
    ueberzugpp

    #virt-manager        # GUI para gerenciamento de VMs
    # hyprlandPlugins.hyprexpo
];

  system.activationScripts.lvimConfig = {
    text = ''
      #!/usr/bin/env bash

      cat > /home/akil/.config/lvim/config.lua << 'EOF'
lvim.autocommands = {
  {
    "ColorScheme",
    {
      pattern = "*",
      callback = function()
        local transparent_groups = {
          "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "VertSplit",
          "StatusLine", "TabLine", "TabLineFill", "TabLineSel", "Pmenu",
          "PmenuSel", "WinSeparator", "FloatBorder", "MsgArea", "CursorLineNr",
          "LineNr", "Folded", "NormalFloat", "TelescopeNormal", "TelescopeBorder",
          "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NvimTreeVertSplit"
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" }) -- background transparency
        end
      end,
    },
  },
}
EOF

      chown akil:users /home/akil/.config/hypr/hyprland.conf  
      chmod 644 /home/akil/.config/hypr/hyprland.conf    
    '';
  };
  
 system.activationScripts.lvimConfigRoot = {
    text = ''
      #!/usr/bin/env bash

      cat > /root/.config/lvim/config.lua << 'EOF'
lvim.autocommands = {
  {
    "ColorScheme",
    {
      pattern = "*",
      callback = function()
        local transparent_groups = {
          "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "VertSplit",
          "StatusLine", "TabLine", "TabLineFill", "TabLineSel", "Pmenu",
          "PmenuSel", "WinSeparator", "FloatBorder", "MsgArea", "CursorLineNr",
          "LineNr", "Folded", "NormalFloat", "TelescopeNormal", "TelescopeBorder",
          "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NvimTreeVertSplit"
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" }) -- background transparency
        end
      end,
    },
  },
}
EOF
 
    '';
  };

system.activationScripts.setupWayfireFish = {
  text = ''
    #!/usr/bin/env bash

    # Garante que o diretório de configuração do fish existe

    # Cria o config.fish com autostart do wayfire em tty1
    cat > /home/akil/.config/fish/config.fish << 'EOF'
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
    exec Hyprland
end
EOF

  '';
};

system.activationScripts.librewolfUserChrome = {
  text = ''
    #!/usr/bin/env bash
    user_home="/home/akil"
    for prof in "$user_home/.librewolf"/*.default; do
      [ -d "$prof" ] || continue                # skip if not a directory
      mkdir -p "$prof/chrome"                  # ensure chrome folder
      ${pkgs.curl}/bin/curl -fsSL \
        https://raw.githubusercontent.com/AKYlU/Firafox_UI/main/Default--Release/userChrome.css \
        -o "$prof/chrome/userChrome.css"       # download stylesheet
    done
  '';
};

  system.activationScripts.wayfireConfig = {
    text = ''
      #!/usr/bin/env bash 

      cat > /home/akil/.config/hypr/hyprland.conf << 'EOF'
general {
    gaps_in = 0                   # Espaço interno entre as janelas
    gaps_out = 0                  # Espaço externo entre as janelas
    border_size = 0               # Tamanho da borda das janelas (-1 para remover)
}

decoration {
    rounding = 15                 # Arredondamento das bordas das janelas    
    dim_special = 0.0             # desativar qualquer escurecimento de áreas ao redor de janelas ou workspaces especiais
}

animations { 
    enabled = false               # Desativar animações
} 

input {
    follow_mouse = 2              # Foco segue o movimento do mouse
    accel_profile = flat          # sem aceleração
}

misc {
    force_default_wallpaper = 0   # Nenhum papel de parede será aplicado
    disable_hyprland_logo = true  # Desativa o logotipo do Hyprland
}

monitor = ,preferred,auto,auto    # Configuração de Monitor

$mainMod = SUPER                  # Definir a Tecla Modificadora Principal (Tecla SUPER)

bind = $mainMod, w, killactive                  # Fechar janela ativa
bind = $mainMod shift, e, exit                  # Sair
bind = $mainMod SHIFT, Space, togglefloating    # Alternar entre janelas flutuantes

bindm = $mainMod, mouse:272, movewindow         # Mover janela
bindm = $mainMod, mouse:273, resizewindow       # Redimensionar janela

# exec-once = hyprctl dispatch workspace special:magic && librewolf  # Iniciar Firefox no workspace -98 (special:magic)
exec-once = swww-daemon
exec-once = wlsunset -T 3001 -t 3000 -S 00:01 -s 00:02

bind = $mainMod, Return, exec, kitty --override background_opacity=0.6             # Abrir terminal
bind = $mainMod, b, exec, blender              # Abrir Blender
bind = $mainMod, s, exec, steam                  # Abrir Steam
bind = $mainMod, m, exec, prismlauncher          # Abrir Prisms Launcher
bind = $mainMod, n, exec, librewolf                # Abrir navegador Firefox
bind = $mainMod, u, exec, unityhub
bind = $mainMod, e, exec, kitty --override background_opacity=0.6 ranger
bind = $mainMod, l, exec, kitty -e sudo env "PATH=$PATH" lvim # Abre o terminal alacritty com o comando sudo lvim
bindl = $mainMod, q, exec, playerctl play-pause  # Alterna entre play e pause no player de mídia
bindl = $mainMod, z, exec, playerctl previous    # Reproduz a música anterior no player de mídia
bindl = $mainMod, a, exec, playerctl next        # Reproduz a próxima música no player de mídia
bind = , PAUSE, exec, hyprshot -m region --clipboard-only --freeze

bind = $mainMod, Grave, togglespecialworkspace, magic         # Alternar workspace especial (magic)
bind = $mainMod SHIFT, Grave, movetoworkspace, special:magic  # Mover para o workspace especial
bind = $mainMod, 1, workspace, 1                 # Muda para o workspace 1
bind = $mainMod SHIFT, 1, movetoworkspace, 1     # Move a janela atual para o workspace 1

# windowrule = workspace 1, steam              # Move a janela da Steam para o workspace 1
# windowrule = workspace 1, steam_app_.*

bindel = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%  # Aumenta o volume
bindel = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%  # Diminui o volume

windowrulev2 = float, class:.*    # Faz com que TODAS as janelas sejam flutuantes
EOF

      chown akil:users /home/akil/.config/hypr/hyprland.conf  
      chmod 644 /home/akil/.config/hypr/hyprland.conf         
    '';
  };

  system.stateVersion = "25.05";     # Versão do estado do sistema para atualizações
}

