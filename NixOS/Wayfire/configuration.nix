{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                  # Habilita o carregador de sistema systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;             # Permite ao NixOS escrever variáveis EFI

  nixpkgs.config.allowUnfree = true;                       # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  time.timeZone = "America/Sao_Paulo";                   # Define o fuso horário do sistema
  i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "us";                                  # Define o layout de teclado do console

  networking.networkmanager.enable = true;                 # Habilita o NetworkManager para gerenciar conexão de rede

  users.users.akyil = {                                     # Configuração do usuário 'akyil'
    isNormalUser = true;                                   # Usuário não-root
    description = "Usuário Akyil";                       # Descrição do usuário
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ];  # Grupos adicionais
    shell = pkgs.fish;                                     # Define o shell padrão como Fish
  };

  programs.fish.enable = true;                             # Habilita o Fish como shell interativo

  programs.xwayland.enable = true;                         # Habilita o XWayland para compatibilidade X11

  hardware.pulseaudio.enable = false;                      # Desabilita PulseAudio
  services.pipewire = {                                     # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                    # Suporte ALSA
    alsa.support32Bit = true;                              # Suporte a bins de 32 bits
    pulse.enable = true;                                   # Habilita compatibilidade PulseAudio
    jack.enable = true;                                    # Habilita compatibilidade JACK
  };

  xdg.portal = {                                           # Configura portais XDG para sandboxing
    enable = true;
    config.common.default = "*";                         # Permite todos por padrão
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk                         # Portal GTK
      pkgs.xdg-desktop-portal-wlr                         # Portal WLR para Wayland
    ];
  };

  virtualisation.libvirtd.enable = true;                  # Habilita o serviço libvirtd para VMs

  services.spice-vdagentd.enable = true;                  # Habilita o agente SPICE para VMs

  programs.dconf.enable = true;                           # Habilita dconf para configurações de desktop

  networking.firewall.allowedTCPPorts = [ 6969 ];         # Abre porta TCP 6969 no firewall
  # Se UDP for necessário, descomente a linha abaixo
  # networking.firewall.allowedUDPPorts = [ 6969 ];       # Abre porta UDP 6969

  environment.systemPackages = with pkgs; [                # Pacotes instalados globalmente
    blender-hip         # Programa de modelagem 3D especializado
    reaper              # DAW para edição de áudio
    unityhub            # Hub do Unity Engine
    android-studio      # IDE Android
    virt-manager        # GUI para gerenciamento de VMs
    vivaldi             # Navegador baseado em Chromium
    lunarvim            # Editor de texto (configurado como IDE)

    wayfire             # Compositor Wayland (Wayfire)
    xwayland            # Compatibilidade X11 no Wayland
    wlsunset            # Ajuste de temperatura de cor no Wayland

    libsForQt5.dolphin  # Dolphin file manager (Qt5)
    libsForQt5.ark      # Ark para compressão/extração (Qt5)
    unzip               # Descompactador de ZIP
    unrar               # Descompactador de RAR

    steam               # Plataforma de jogos Steam
    lutris              # Gerenciador de jogos
    prismlauncher       # Launcher para jogos Prismatik
    jdk21               # Java Development Kit 21

    pulseaudio          # Cliente PulseAudio (requerido por alguns apps)
    playerctl           # Controle de player via CLI

    libsForQt5.konsole  # Terminal Konsole (Qt5)
    fish                # Fish shell
    fastfetch           # Ferramenta de info de sistema

    jetbrains-mono      # Fonte JetBrains Mono
    noto-fonts-cjk-sans # Fontes Noto CJK sans
  ];

  hardware.graphics = {                                    # Configurações de GPU
    enable = true;                                         # Habilita drivers gráficos
    enable32Bit = true;                                    # Habilita drivers 32 bits
    extraPackages = with pkgs; [                           # Pacotes extras para GPU
      mesa.drivers
      libva
      libvdpau
      vaapiVdpau
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [          # Pacotes extras 32-bit para GPU
      mesa.drivers
      libva
      libvdpau
      vaapiVdpau
    ];
  };

  programs.steam = {                                       # Configuração customizada do Steam
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [                       # Adiciona bibliotecas Vulkan e compatibilidade
        vulkan-loader
        vulkan-validation-layers
        libva
        libvdpau
      ];
    };
  };

  fonts = {                                                # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;                                       # Habilita fontconfig
      antialias = true;                                    # Habilitação de antialias
      hinting.enable = true;                               # Habilita hinting
      subpixel.rgba = "rgb";                             # Subpixel rendering RGB
    };
  };

  programs.java = {                                        # Configuração do Java
    enable = true;
    package = pkgs.jdk21;                                  # Define pacote JDK21
  };

  security.sudo.enable = true;                             # Habilita sudo
  security.sudo.wheelNeedsPassword = false;                # Usuários do grupo wheel não precisam de senha

  environment.sessionVariables = {                         # Variáveis de ambiente para sessões
    QT_QPA_PLATFORM = "wayland";                         # Define plataforma Qt para Wayland
    QT_QPA_PLATFORMTHEME = "qt5ct";                      # Tema Qt5CT
    QT_STYLE_OVERRIDE = "Fusion";                        # Força estilo Fusion no Qt
    GTK_THEME = "Adwaita:dark";                          # Tema GTK Adwaita escuro
  };

  system.stateVersion = "23.11";                         # Versão do estado do sistema para atualizações
}

