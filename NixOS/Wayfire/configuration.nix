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
  console.keyMap = "us";

  networking.networkmanager.enable = true;

  users.users.akyil = {
    isNormalUser = true;
    description = "Usuário Akyil";
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ];
    shell = pkgs.fish;
  };

  services.flatpak.enable = true;

  programs.fish.enable = true;

  programs.xwayland.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  virtualisation.libvirtd.enable = true;

  services.spice-vdagentd.enable = true;

  programs.dconf.enable = true;

  networking.firewall.allowedTCPPorts = [ 6969 ];
  # Se você também precisar de UDP (geralmente não é o caso para o Spigot):
  # networking.firewall.allowedUDPPorts = [ 6969 ];

  environment.systemPackages = with pkgs; [ 
    blender-hip reaper unityhub android-studio #protividade
    fish
    lutris
    git
    curl
    wget
    fastfetch
    wayfire
    xwayland
    virt-manager spice-gtk spice-protocol #vm
    vivaldi
    btop
    parsec-bin
    vulkan-tools
    vulkan-loader
    unzip unrar libsForQt5.ark #istrair
    wlsunset
    rustdesk
    lunarvim
    prismlauncher jdk21 #minecraft
    steam
    pulseaudio playerctl #comtrole de som
    libsForQt5.dolphin
    gnome-themes-extra libsForQt5.breeze-icons libsForQt5.qt5ct # tema
    libsForQt5.konsole
    mononoki dejavu_fonts fira-code jetbrains-mono hack-font dejavu_fonts liberation_ttf_v1 noto-fonts noto-fonts-emoji-blob-bin noto-fonts-cjk-sans #fots
    gamescope
];

hardware.graphics = {
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [
    mesa.drivers
    libva
    libvdpau
    vaapiVdpau
  ];
  extraPackages32 = with pkgs.pkgsi686Linux; [
    mesa.drivers
    libva
    libvdpau
    vaapiVdpau
  ];
};

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        libva
        libvdpau
      ];
    };
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

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

#  hardware.graphics.enable = true;
 
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "Fusion"; 
    GTK_THEME = "Adwaita:dark";
};

  system.stateVersion = "23.11";
 } 
