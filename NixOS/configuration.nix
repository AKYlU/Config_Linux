{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  #### BOOT
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "btusb" ]; # Bluetooth USB
  };

  #### HOSTNAME E REDE
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  #### LOCALE E FUSO HORÁRIO
  time.timeZone = "America/Recife";

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
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
  };

  #### INTERFACE GRÁFICA: X11 + I3WM + DISPLAY MANAGER
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    windowManager.i3.enable = true;
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = false;
      autoLogin.enable = true;
      autoLogin.user = "anjl";
    };
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "x11";
    QT_QPA_PLATFORM = "xcb";
  };

  #### PORTAIS E FLATPAK
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  #### ÁUDIO: PIPEWIRE
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  security.rtkit.enable = true;

  #### BLUETOOTH
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  #### IMPRESSÃO
  services.printing.enable = true;

  #### USUÁRIO
  users.users.anjl = {
    isNormalUser = true;
    description = "anjl";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  #### PROGRAMAS DO SISTEMA
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  #### OUTRAS CONFIGS
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
