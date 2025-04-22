{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];

  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;           # Permite ao NixOS escrever variáveis EFI

  nixpkgs.config.allowUnfree = true;                     # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  time.timeZone = "America/Sao_Paulo";                   # Define o fuso horário do sistema
  i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "br-abnt2";                           # Define o layout de teclado do console

  # Bluetooth
  hardware.bluetooth.enable = true;                      # Ativa suporte Bluetooth via kernel/bluez
  services.bluetooth.enable = true;                      # Ativa o serviço do daemon Bluetooth (bluetoothd)
  services.blueman.enable = true;                        # Interface gráfica Blueman para gerenciamento via GUI
  services.bluetooth.settings = {                        # Configuração do daemon Bluetooth
    General = {
      AutoEnable = true;                                 # Ativa adaptador automaticamente no boot
    };
  };

  services.flatpak.enable = true;                        # Habilita suporte ao Flatpak

  networking.networkmanager.enable = true;               # Gerenciador de rede padrão

  users.users.akyila = {
    isNormalUser = true;
    description = "Usuário Akyil";
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ]; # Grupos adicionais
    shell = pkgs.fish;
  };

  programs.fish.enable = true;                           # Ativa o shell Fish para o sistema

  programs.xwayland.enable = true;                       # Ativa compatibilidade X11 no Wayland

  hardware.pulseaudio.enable = false;                    # Desativa PulseAudio (substituído por PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";                         # Portal padrão
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [
    firefox-esr
    discord
    gnome-software
    networkmanagerapplet

    wayfire
    xwayland
    wlsunset
    grim
    slurp
    bemenu
    wayfirePlugins.wf-shell
    wayfirePlugins.wcm

    libsForQt5.dolphin
    libsForQt5.ark
    unzip
    unrar

    steam
    lutris

    pulseaudio               # Algumas apps ainda exigem cliente PulseAudio
    playerctl

    libsForQt5.konsole
    fish
    fastfetch

    noto-fonts-cjk-sans
    libsForQt5.qt5ct
    libsForQt5.breeze-icons 
    papirus-icon-theme

    fuse3
    lxde.lxsession
    gnome-themes-extra
    cantarell-fonts
    fontconfig
  ];

  programs.fuse.userAllowOther = true;                   # Permite FUSE para usuários normais

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      subpixel.rgba = "rgb";
    };
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Fusion";
    GTK_THEME = "Adwaita:dark";
  };

  system.stateVersion = "23.11";                         # Fixa o estado do sistema na versão 23.11
}
