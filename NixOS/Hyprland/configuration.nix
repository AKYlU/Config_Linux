{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix                         # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;                     # Permite pacotes com licenças não-livres

  networking.hostName = "NixOS";                         # Define o nome de host da máquina
  time.timeZone = "America/Recife";                      # Define o fuso horário do sistema
  console.keyMap = "us";                                 # Define o layout de teclado do console

  networking.networkmanager.enable = true;

  users.users.akil = {                                   # Configuração do usuário 'akyil'
    isNormalUser = true;                                 # Usuário não-root
    uid = 1000;                                          # ID de usuário
    extraGroups = ["video" "audio" "plugdev" "storage"];         # Grupos adicionais
    shell = pkgs.fish;                                   # Define o shell padrão como Fish
  };

  services.udisks2.enable = true;                        # ver Disco

  programs.fish.enable = true;                           # Habilita o Fish como shell interativo

  users.users.root = {
   shell = pkgs.fish;                                    # Define fish como shell padrão do root
  };

  hardware.pulseaudio.enable = false;                    # Desabilita PulseAudio
  services.pipewire = {                                  # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                  # Suporte ALSA
    pulse.enable = true;                                 # Habilita compatibilidade PulseAudio
    jack.enable = true;                                 # Habilita compatibilidade JACK
  };

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];      # DNS

  services.getty.autologinUser = "akil";                 # Autologin em tty1

  security.polkit.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 0;                # Define o nível de uso da swap

  services.keyd = {                                      # Atalho ou Macro
    enable = true;

  keyboards.default = {                                  # Atalho ou Macro
    ids = [ "*" ];                                       # Como colocar Macro = "macro(pageup up)"; 
    settings = {        # comando -> keyd list-keys      # lista toda os butao
      main = {          # sudo libinput debug-events     # para pode ver o atalho seto
        compose      = "right";                          # remapeia Menu → seta para a direita
        rightalt     = "left";                           # Alt direito vira seta para a esquerda
        rightcontrol = "down";                           # Ctrl direito vira seta para baixo
        rightshift   = "up";                             # Shift direito vira seta para cima
        capslock     = "delete";
       #  backspace    = "pageup";
        leftmeta     = "leftalt";
        rightmeta   = "pageup";
        leftalt      = "pagedown";
      };
    };
  };
};

   hardware.graphics = {                                 # Configurações de GPU para steam
    enable = true;                                       # Habilita drivers gráficos
    enable32Bit = true;   
   };

   fonts = {                                             # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
 };

 programs.java = {                                       # Configuração do Java
    enable = true;
    package = pkgs.jdk21;                                # Define pacote JDK21
   };

  services.avahi.enable = false;                         # Desative se não precisar de descoberta de rede local
  services.openssh.enable = false;                       # Só ative se realmente for usar acesso remoto
  services.printing.enable = false;                      # Desative se não tiver impressora
  systemd.network.wait-online.enable = false;            # Desativa a espera por rede online no boot
  services.timesyncd.enable = false;                     # Desativa sincronização de horário (útil em desktop offline)
  networking.firewall.enable = false;                    # Desativa o firewall (se não for necessário)
  services.xserver.enable = false;                       # Não use X11 nem Display Manager
  services.displayManager.enable = false;
  services.upower.enable = false;                        # sem gerenciamento de bateria/suspensão  
  services.accounts-daemon.enable = false;               # remove daemon de gerenciamento de usuários 
  services.geoclue2.enable = false;                      # remove localização baseada em IP        
  services.resolved.enable = false;
  networking.useDHCP = false;
  hardware.alsa.enable = false;                          # desativa ALSA no nível do kernel/usuário
  programs.dconf.enable = true;                          # pode gravar usando kooha
  services.dbus.enable = true;                           # para disco?

  systemd.services."bluetooth.target".wantedBy = lib.mkForce [];    # força que bluetooth.target nunca seja Wanted
  systemd.services."bluetooth.target".after    = lib.mkForce [];    # garante que nada fique After=bluetooth.target

  boot.blacklistedKernelModules = [                      # Blacklist dos módulos de kernel Bluetooth
    "btusb"                                              # driver USB Bluetooth
    "bluetooth"                                          # módulo genérico Bluetooth
  ];

services.journald = {
  storage     = "none";                                  # sem logs em disco
  extraConfig = ''                                       # caso queira ainda alguma diretiva mínima
    RuntimeMaxUse   = 0                                  # 0 bytes em RAM
    RuntimeKeepFree = 1M                                 # sempre 1 MiB livre
  '';
};

  hardware.enableAllFirmware = false;                    # só firmware explicitamente necessário  
  boot.initrd.kernelModules = [ "amdgpu" ];              # apenas o driver da iGPU Vega           
  boot.kernelModules = [ ];                              # limpa módulos extras                   

xdg.portal = {
  enable = true;

  # Permitir todos os portais por padrão
  config.common.default = "*";

  # Portais adicionais: Hyprland, GTK e WLR
  extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
  ];
};

  environment.systemPackages = with pkgs; [              # Pacotes instalados globalmente

    blender             # Programa de modelagem 3D especializado    # openutau             # UTAU
    reaper              # DAW para edição de áudio                  # qpwgraph             # para manda som da utau
                                                                    # mpvpaper             # wallpepar
    unityhub            # Hub do Unity Engine                       # noto-fonts-cjk-sans  # Fontes Noto CJK sans  
    librewolf           # Firefox                                   # xdg-utils            # xdg-open
                                                                    # virt-manager         # GUI para gerenciamento de VMs
    lunarvim            # Editor de texto (configurado como IDE)
    btop-rocm           # Cpu

    hyprshot            # foto
    hyprland            # geresiado de janela
    xwayland            # "X11"
    swww                # Wallpaper
    wlsunset            # Ajuste de temperatura de cor no Wayland
    kooha               # gravador  
    pulseaudio          # Cliente PulseAudio (requerido por alguns apps)
    wl-clipboard        # copiar/colar 
    done                # e para codigo
    playerctl           # Controle de player via CLI
    
    steam               # Plataforma de jogos Steam
    prismlauncher       # Launcher para jogos Prismatik
    jdk21               # Java Development Kit 21

    kdePackages.dolphin # File
    kdePackages.konsole # Terminal
    kdePackages.ark     # Extrair
    unzip               # zip
    unrar               # rar
    dconf               # Para o Kooha

    adwaita-icon-theme           # Ponteiro do Mouse
    kdePackages.partitionmanager # Disco
    lxqt.lxqt-policykit          # Para da Root

    ffmpeg                       # Blender gravar
    alsa-utils                   # Gravar
];

  system.activationScripts.lvimConfig = {  # Para deixa o Lvim transparent
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
  
 system.activationScripts.lvimConfigRoot = {  # Para deixa o Lvim transparent em Root
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

system.activationScripts.setupWayfireFish = {   # Para pode entra no Hyprland automaticamente
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

  system.activationScripts.wayfireConfig = {   # Configurasao do Hyprland
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
    follow_mouse = 1              # Foco segue o movimento do mouse
    accel_profile = flat          # sem aceleração
}

misc {
    force_default_wallpaper = 0   # Nenhum papel de parede será aplicado
    disable_hyprland_logo = true  # Desativa o logotipo do Hyprland
}

env = XCURSOR_THEME,Adwaita
env = XCURSOR_SIZE,16
exec-once = hyprctl setcursor Adwaita 16

monitor = ,preferred,auto,0.833333     # Configuração de Monitor

$mainMod = ALT                       # Definir a Tecla Modificadora Principal (Tecla SUPER)

bind = $mainMod, w, killactive                  # Fechar janela ativa
bind = $mainMod shift, e, exit                  # Sair
bind = $mainMod SHIFT, Space, togglefloating    # Alternar entre janelas flutuantes

bindm = $mainMod, mouse:272, movewindow         # Mover janela
bindm = $mainMod, mouse:273, resizewindow       # Redimensionar janela

# exec-once = hyprctl dispatch workspace special:magic && librewolf  # Iniciar Firefox no workspace -98 (special:magic)
exec-once = swww-daemon
exec-once = wlsunset -T 3001 -t 3000 -S 00:01 -s 00:02
exec-once = steam -silent && swww img /home/akil/Downloads/Img/Wallpaper/0001.jpg
# exec-once = unityhub -silent
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
exec-once = librewolf
exec-once = lxqt-policykit-agent

bind = $mainMod, Return, exec, konsole           # Abrir terminal
bind = $mainMod, b, exec, blender                # Abrir Blender
bind = $mainMod, s, exec, hyprctl dispatch workspace special:magic && steam                  # Abrir Steam
bind = $mainMod, m, exec, prismlauncher          # Abrir Prisms Launcher
bind = $mainMod, n, exec, librewolf              # Abrir navegador Firefox
bind = $mainMod, u, exec, unityhub
bind = $mainMod, e, exec, dolphin
bind = $mainMod, l, exec, kitty -e sudo env "PATH=$PATH" lvim # Abre o terminal alacritty com o comando sudo lvim
bindl = $mainMod, q, exec, playerctl play-pause  # Alterna entre play e pause no player de mídia
bindl = $mainMod, z, exec, playerctl previous    # Reproduz a música anterior no player de mídia
bindl = $mainMod, a, exec, playerctl next        # Reproduz a próxima música no player de mídia
bind = $mainMod, Tab, exec, hyprshot -m region --clipboard-only --freeze
bind = $mainMod, delete, exec, kooha
bind = $mainMod, f, fullscreen
bind = $mainMod, p, exec, reaper

bind = $mainMod, Grave, togglespecialworkspace, magic         # Alternar workspace especial (magic)
bind = $mainMod SHIFT, Grave, movetoworkspace, special:magic  # Mover para o workspace especial
bind = $mainMod, 1, workspace, 1                 # Muda para o workspace 1
bind = $mainMod SHIFT, 1, movetoworkspace, 1     # Move a janela atual para o workspace 1

bindel = ,XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%  # Aumenta o volume
bindel = ,XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%  # Diminui o volume

windowrulev2 = float, class:.*                      # Faz com que TODAS as janelas sejam flutuantes
windowrule = opacity 1 0.8 1, class:.*              # Definir opacidade das janelas
windowrulev2 = opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$
windowrulev2 = pin, title:^(Picture-in-Picture)$
#windowrulev2 = workspace 2, class:^(steam)$, title:^Steam$
#windowrulev2 = workspace 2 silent, class:^(steam_app_.*)$
windowrulev2 = size 920 520, title:^(Picture-in-Picture)$
windowrulev2 = size 750 450, class:^(org.kde.konsole)$
windowrulev2 = workspace special:magic silent, class:^(steam_app_.*)$
EOF

      chown akil:users /home/akil/.config/hypr/hyprland.conf  
      chmod 644 /home/akil/.config/hypr/hyprland.conf         
    '';
  };

system.activationScripts.librewolfUserChrome = {   # Ui do Firefox Para deixa transparent e coloca dentro do site a barra
  text = ''
    #!/usr/bin/env bash

    user_home="/home/akil"

    for prof in "$user_home/.librewolf"/*.default; do
      [ -d "$prof" ] || continue

      chrome_dir="$prof/chrome"
      mkdir -p "$chrome_dir"

      # Escreve userChrome.css com CSS personalizado
      cat > "$chrome_dir/userChrome.css" << 'EOF'
/* ——— ROOT & variáveis ——— */
:root {
  background: transparent !important;
  --tabpanel-background-color: #0000 !important;
  /* altura fixa da barra de abas */
  --tab-min-height: 4px !important;
  /* remove a linha entre abas e conteúdo */
  --tabs-border-color: rgba(0,0,0,0) !important;
}

/* Habilitar via about:config:
   toolkit.legacyUserProfileCustomizations.stylesheets = true
   browser.tabs.allow_transparent_browser = true */

/* ——— Janela principal e barras ——— */
#main-window,
#navigator-toolbox,
#titlebar,
#nav-bar,
#PersonalToolbar {
  background: transparent !important;
  box-shadow: none !important;
  border: none !important;
  pointer-events: auto !important;
  position: relative !important;
  z-index: 2147483647 !important;
}

/* ——— Autohide discreto da barra de abas (altura fixa de 4px) ——— */
#TabsToolbar {
  height: var(--tab-min-height) !important;  /* 4px */
  opacity: 0.3 !important;                   /* quase invisível */
  pointer-events: none !important;           /* não bloqueia clique */
  transition: opacity 0.15s ease;            /* transição suave */
}
#navigator-toolbox:hover > #TabsToolbar,
#TabsToolbar:hover {
  opacity: 1 !important;                     /* visível ao hover */
  pointer-events: auto !important;           /* habilita clique */
}

/* ——— Garante que as próprias abas e o botão “+” sejam clicáveis ——— */
#tabbrowser-tabs,
.tabbrowser-tab,
.tabs-newtab-button {
  pointer-events: auto !important;
}
/* remove interferência de áreas vazias no clique */
#tabbrowser-tabs .arrowscrollbox-scrollbox {
  pointer-events: none !important;
}

/* ——— Abas (blur, sem borda/sombra) ——— */
.tabbrowser-tab {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  flex-grow: 0 !important;
  flex-shrink: 1 !important;
  margin-inline: 0 !important;
}
.tab-background { background: transparent !important; border: none !important; }
.tabbrowser-tab[selected] .tab-background {
  background-color: rgba(30,30,30,0.25) !important;
  backdrop-filter: blur(14px) !important;
}
.tabbrowser-tab:not([selected]) .tab-background {
  background-color: rgba(30,30,30,0.1) !important;
  backdrop-filter: blur(6px) !important;
}
/* Texto das abas */
.tabbrowser-tab .tab-label { color: rgba(255,255,255,0.7) !important; }
.tabbrowser-tab[selected] .tab-label { color: #fff !important; }

/* ——— Barra de endereço e busca com blur ——— */
#urlbar-background,
#searchbar {
  background-color: rgba(20,20,20,0.3) !important;
  backdrop-filter: blur(10px) !important;
  box-shadow: none !important;
  border: none !important;
}

/* ——— Menus, popups, botões ——— */
#PanelUI-button,
#PanelUI-button > .toolbarbutton-icon,
menupopup,
.popup-internal-box,
.panel-subview-body,
.panel-arrowcontent {
  background-color: rgba(25,25,25,0.4) !important;
  backdrop-filter: blur(16px) !important;
  box-shadow: none !important;
  border: none !important;
  color: white !important;
}
/* remove foco visual extra */
*:-moz-focusring { outline: none !important; }
/* oculta botões de fechar/ “todas abas” */
.tab-close-button,
#alltabs-button { display: none !important; }
/* tooltips imediatos, sem animações */
tooltip, .tooltip * {
  animation: none !important;
  transition: none !important;
  animation-delay: 0 !important;
  transition-delay: 0 !important;
}
.tooltip-label {
  display: block !important;
  opacity: 1 !important;
  transition-delay: 0 !important;
}

/* ——— Barra de favoritos e ajustes de layout ——— */
#PersonalToolbar { height: 17px !important; }
#navigator-toolbox { margin-top: -12px !important; }
#nav-bar { margin-top: -70px !important; overflow: hidden !important; }
#TabsToolbar { overflow: hidden !important; }

/* ——— Downloads & extensões clicáveis ——— */
#downloads-button,
#downloads-button .toolbarbutton-dropdown-button,
#unified-extensions-button,
#unified-extensions-button > .toolbarbutton-icon,
#unified-extensions-button > .toolbarbutton-badge-stack {
  pointer-events: auto !important;
  position: relative !important;
  z-index: 2147483648 !important;
  opacity: 1 !important;
  filter: none !important;
}
EOF

      chown akil:users "$chrome_dir/userChrome.css"
      chmod 644 "$chrome_dir/userChrome.css"
    done
  '';
};
  system.stateVersion = "25.05";     # Versão do estado do sistema para atualizações
}

