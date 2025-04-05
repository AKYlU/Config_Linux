{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "btusb" ];  # Bluetooth USB

  # Hostname e rede
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale e fuso horário
  time.timeZone = "America/Recife";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # X11 + i3wm
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.xkb.layout = "us";

  # Display Manager (SDDM com X11)
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = false;
    autoLogin.enable = true;
    autoLogin.user = "anjl";
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
  };

  # Portais (Flatpak etc)
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Som (PipeWire)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  # Impressão
  services.printing.enable = true;

  # Usuário
  users.users.anjl = {
    isNormalUser = true;
    description = "anjl";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Programas do sistema
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  # Permitir pacotes não livres
  nixpkgs.config.allowUnfree = true;

  # Versão do estado do sistema
  system.stateVersion = "24.11";
}
