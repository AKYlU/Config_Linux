{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "wayfire-nixos";
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "br-abnt2";

  # NetworkManager
  networking.networkmanager.enable = true;

  users.users.akyila = {
    isNormalUser = true;
    description = "Usuário Akyil";
    extraGroups = [ "wheel" "video" "audio" ];
  };

  programs.xwayland.enable = false; # Desabilitado para um ambiente Wayland puro

  # PipeWire no lugar do PulseAudio
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false; # Remover Jack se não usar para áudio profissional
  };

  # XDG Portals para integração com Flatpak, GTK e Wayland
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [
    blueman           # Gerenciador de Bluetooth, necessário se usar Bluetooth
    bluez             # Gerenciador de Bluetooth
    firefox-esr       # Navegador leve e confiável
    discord           # Comunicação
    networkmanagerapplet
    grim
    slurp
    pavucontrol
    wl-clipboard

    lutris
    steam

    noto-fonts-cjk-sans  # Fontes simples para não sobrecarregar
    gnome-themes-extra   # Tema simples para Wayland
    cantarell-fonts      # Somente se necessário
    fontconfig           # Configuração de fontes

    wayfire
    wayfirePlugins.wf-shell
    wayfirePlugins.wcm

    libsForQt5.dolphin
    libsForQt5.ark
    unzip
    unrar

    foot
    swww
    noto-fonts-cjk-sans # Fontes Noto CJK sans
    libsForQt5.qt5ct
  ];

  # Bluetooth
  systemd.services.bluetooth = {
    enable = true;  # Desabilitar se você não usa Bluetooth
  };

  # Gráficos Intel
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configuração de fontes para performance otimizada
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };

  # Variáveis de ambiente para desempenho
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "Fusion";    # Força estilo Fusion no Qt
  };

  system.stateVersion = "23.11";
}

