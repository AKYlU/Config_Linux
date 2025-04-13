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

  programs.fish.enable = true;

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
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

  environment.systemPackages = with pkgs; [
    foot
    blender-hip
    fish
    lutris
    git
    curl
    wget
    fastfetch
    wayfire
    xwayland
    virt-manager
    vivaldi
    btop
    unityhub
    parsec-bin
    vulkan-tools
    vulkan-loader
    unzip
    file
    wlsunset
    rustdesk
    lunarvim
    prismlauncher
    OVMF
 ];

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  hardware.graphics.enable = true;

  environment.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
  };

  # Cria links simbólicos para os arquivos de firmware EFI usando o pacote OVMF
  system.activationScripts.ovmf = {
    text = ''
      mkdir -p /usr/share/OVMF
      ln -sf ${pkgs.OVMF}/share/OVMF/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE.fd
      ln -sf ${pkgs.OVMF}/share/OVMF/OVMF_VARS.fd /usr/share/OVMF/OVMF_VARS.fd
    '';
  };

  system.stateVersion = "23.11";
}
