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

  # Flatpak e integração com gnome-software
  services.flatpak.enable = true;

  # NetworkManager
  networking.networkmanager.enable = true;

  users.users.akyila = {
    isNormalUser = true;
    description = "Usuário Akyil";
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.xwayland.enable = true;

  # PipeWire no lugar do PulseAudio
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # XDG Portals para integração com Flatpak, GTK e Wayland
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages = with pkgs; [

    blueman         # Ferramenta gráfica para gerenciar dispositivos Bluetooth
    bluez           # Gerenciador de Bluetooth (necessário)
    pavucontrol

    firefox-esr
    discord
    gnome-software                            # Centro de aplicativos
    gnome.gnome-software                      # redundância (alguns casos precisa)
    gnome.gnome-control-center                # necessário para configurar fontes Flatpak
    gnome.gnome-settings-daemon               # integração de configurações GNOME
    gnome.gnome-keyring                       # chaveiro para autenticação Flatpak
    gnome.glib-networking                     # necessário para plugins funcionarem
    gnome.gnome-software-plugin-flatpak       # plugin para suporte ao Flatpak no gnome-software
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

    pulseaudio
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

 # Habilitar o serviço Bluetooth
systemd.services.bluetooth = {
  enable = true;
};
 
  programs.fuse.userAllowOther = true;

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

  system.stateVersion = "23.11";
}
