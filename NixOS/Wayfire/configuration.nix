{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;           # Permite ao NixOS escrever variáveis EFI

  system.autoUpgrade.enable = true;                      # updete
  system.autoUpgrade.allowReboot = true;

  programs.appimage.enable = true;                       # AppImage
  programs.appimage.binfmt = true;

  programs.appimage.package = pkgs.appimage-run.override { 
    extraPkgs = pkgs: [
      # missing libraries here, e.g.: `pkgs.libepoxy`    # appimage
    ];
  };

  nixpkgs.config.allowUnfree = true;                     # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  time.timeZone = "America/Sao_Paulo";                   # Define o fuso horário do sistema
  i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "us";                                 # Define o layout de teclado do console

  networking.networkmanager.enable = true;               # Habilita o NetworkManager para gerenciar conexão de rede

  users.users.akyil = {                                  # Configuração do usuário 'akyil'
    isNormalUser = true;                                 # Usuário não-root
    uid = 1000;                                          # ID de usuário
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ];  # Grupos adicionais
    shell = pkgs.fish;                                   # Define o shell padrão como Fish
  };

  programs.fish.enable = true;                           # Habilita o Fish como shell interativo

  programs.xwayland.enable = true;                       # Habilita o XWayland para compatibilidade X11

  hardware.pulseaudio.enable = false;                    # Desabilita PulseAudio
  services.pipewire = {                                  # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                  # Suporte ALSA
    alsa.support32Bit = true;                            # Suporte a bins de 32 bits
    pulse.enable = true;                                 # Habilita compatibilidade PulseAudio
    jack.enable = true;                                  # Habilita compatibilidade JACK
  };

  xdg.portal = {                                         # Configura portais XDG para sandboxing
    enable = true;
    config.common.default = "*";                         # Permite todos por padrão
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  virtualisation.libvirtd.enable = true;                 # Habilita o serviço libvirtd para VMs

  networking.networkmanager.insertNameservers = [ "94.140.14.15" "94.140.15.16" ];

  networking.firewall.enable = false;                    # firewall 

  # networking.firewall.allowedTCPPorts = [
  #  8090  # Porta para transmissão de som
  #  6969  # Porta para outro serviço (ex: controle remoto)
  #  27015
  # ];

  # networking.firewall.allowedUDPPorts = [
  #  27015 # Porta UDP exigida pelo jogo steam
  # ];


  # Se UDP for necessário, descomente a linha abaixo
  # networking.firewall.allowedUDPPorts = [ 6969 ];      # Abre porta UDP 6969

  environment.systemPackages = with pkgs; [              # Pacotes instalados globalmente

    blender-hip         # Programa de modelagem 3D especializado
    reaper              # DAW para edição de áudio
    openutau            # UTAU
    unityhub            # Hub do Unity Engine

    virt-manager        # GUI para gerenciamento de VMs
    lunarvim            # Editor de texto (configurado como IDE)
    firefox-esr         # firefox

    wayfire             # Compositor Wayland (Wayfire)
    xwayland            # Compatibilidade X11 no Wayland
    wlsunset            # Ajuste de temperatura de cor no Wayland
    grim                # tira foto
    slurp               # seletor
    ffmpeg              # gravador
    wf-recorder         # gravar video
    swww                # wallpepar

    libsForQt5.dolphin  # Dolphin file manager (Qt5)
    libsForQt5.ark      # Ark para compressão/extração (Qt5)
    unzip               # Descompactador de ZIP
    unrar               # Descompactador de RAR

    steam               # Plataforma de jogos Steam
    prismlauncher       # Launcher para jogos Prismatik
    jdk21               # Java Development Kit 21
    git                 # github

    pulseaudio          # Cliente PulseAudio (requerido por alguns apps)
    playerctl           # Controle de player via CLI
    easyeffects         # controlado de som
    qpwgraph            # para manda som da utau   

    libsForQt5.konsole  # Terminal Konsole (Qt5)
    fish                # Fish shell
    fastfetch           # Ferramenta de info de sistema

    noto-fonts-cjk-sans # Fontes Noto CJK sans
 
    libsForQt5.qt5ct                  # tema
    libsForQt5.breeze-icons 
    
    # android-tools                  # adb
  ];

  programs.dconf.enable = true;      # Ativa o backend dconf no sistema para easyeffects

  hardware.graphics = {              # Configurações de GPU para steam
    enable = true;                   # Habilita drivers gráficos
    enable32Bit = true;   
    };

  fonts = {                          # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;                 # Habilita fontconfig
      antialias = true;              # Habilitação de antialias
      hinting.enable = true;         # Habilita hinting
      subpixel.rgba = "rgb";         # Subpixel rendering RGB
    };
  };

  programs.java = {                  # Configuração do Java
    enable = true;
    package = pkgs.jdk21;            # Define pacote JDK21
  };

  environment.sessionVariables = {   # Variáveis de ambiente para sessões
    QT_QPA_PLATFORM = "wayland";     # Define plataforma Qt para Wayland
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Fusion";    # Força estilo Fusion no Qt
    GTK_THEME = "Adwaita:dark";      # Tema GTK Adwaita escuro
  };

  system.stateVersion = "23.11";     # Versão do estado do sistema para atualizações
}

