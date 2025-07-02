{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot
 # boot.loader.efi.canTouchEfiVariables = true;           # Permite ao NixOS escrever variáveis EFI

 # boot.kernelParams = [ "intel_iommu=off" "quiet" "nowatchdog" "intel_pstate=disable" "amd_pstate=disable" "cpufreq.default_governor=performance" "amd_pstate=guided" ];

 # powerManagement.cpuFreqGovernor = "schedutil";

  nixpkgs.config.allowUnfree = true;                      # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  # time.timeZone = "America/Sao_Paulo";                   # Define o fuso horário do sistema
  # i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "us";                                 # Define o layout de teclado do console

  networking.networkmanager.enable = true;
  # networking.useDHCP = false;
  # systemd.network.enable = true;       # habilita systemd-networkd
  # networking.wireless.enable = true;  # ativa wpa_supplicant

  users.users.akyil = {                                  # Configuração do usuário 'akyil'
    isNormalUser = true;                                 # Usuário não-root
    uid = 1000;                                          # ID de usuário
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd" ];  # Grupos adicionais
    shell = pkgs.fish;                                   # Define o shell padrão como Fish
  };

  programs.fish.enable = true;                           # Habilita o Fish como shell interativo

  users.users.root = {
   shell = pkgs.fish;  # Define fish como shell padrão do root
  };

  # programs.xwayland.enable = true;                       # Habilita o XWayland para compatibilidade X11
  # services.xserver.enable = false;

  hardware.pulseaudio.enable = false;                    # Desabilita PulseAudio
  services.pipewire = {                                  # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                  # Suporte ALSA
    alsa.support32Bit = true;                            # Suporte a bins de 32 bits
    pulse.enable = true;                                 # Habilita compatibilidade PulseAudio
    jack.enable = true;                                  # Habilita compatibilidade JACK
  };

 # xdg.portal = {                                         # Configura portais XDG para sandboxing
 #   enable = true;
 #   config.common.default = "*";                         # Permite todos por padrão
 #   extraPortals = [
 #     pkgs.xdg-desktop-portal-gtk
 #     pkgs.xdg-desktop-portal-wlr
 #   ];
 # };

# virtualisation.libvirtd = {
#  enable = true;                   # Ativa o libvirtd
#  qemu = {
#    package = pkgs.qemu_kvm;       # Usa QEMU com suporte KVM
#    runAsRoot = false;             # Para uso como usuário normal
#    swtpm.enable = true;           # TPM opcional, seguro deixar
#  };
#};

#   networking.firewall.allowedTCPPorts = [
#    8090  # Porta para transmissão de som
#    6969  # Porta para outro serviço (ex: controle remoto)
#    27015
#    22
#    8080
#   ];

#   networking.firewall.allowedUDPPorts = [
#    27015 # Porta UDP exigida pelo jogo steam
#   ];

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Se UDP for necessário, descomente a linha abaixo
  # networking.firewall.allowedUDPPorts = [ 6969 ];      # Abre porta UDP 6969

  environment.systemPackages = with pkgs; [              # Pacotes instalados globalmente

    blender             # Programa de modelagem 3D especializado
    reaper              # DAW para edição de áudio
    openutau            # UTAU

    unityhub            # Hub do Unity Engine
    virt-manager        # GUI para gerenciamento de VMs
    librewolf           # Firefox

    # TUI
    lunarvim            # Editor de texto (configurado como IDE)
    ranger              # File
    btop-rocm           # Cpu


    pkgs.wayfirePlugins.wf-shell
    wayfire             # Compositor Wayland (Wayfire)
    wayfirePlugins.wcm  # config do wayfire
    wlsunset            # Ajuste de temperatura de cor no Wayland
    grim                # tira foto
    slurp               # seletor
    ffmpeg              # gravador
    wf-recorder         # gravar video
    qjackctl            # e som tambem mais nao sei para que seve
    # mpvpaper          # wallpepar
    pulseaudio          # Cliente PulseAudio (requerido por alguns apps)
    qpwgraph            # para manda som da utau
    kitty               # Terminal
    noto-fonts-cjk-sans # Fontes Noto CJK sans  
    wl-clipboard        # copiar/colar 
    xclip               # copiar/colar
    premid              # status
    done
    xdg-utils           # xdg-open
    playerctl           # Controle de player via CLI
    
    steam                            # Plataforma de jogos Steam
    prismlauncher                    # Launcher para jogos Prismatik
    
    jdk21                            # Java Development Kit 21
    nodejs_23                        # tema unity
    python3
    python3Packages.flask

    atool               # zip
    unzip               # zip
    unrar               # rar
    desktop-file-utils  # mine
    ueberzugpp
];

system.activationScripts.librewolfUserChrome = {
  text = ''
    #!/usr/bin/env bash
    user_home="/home/akyil"
    for prof in "$user_home/.librewolf"/*.default; do
      [ -d "$prof" ] || continue                # skip if not a directory
      mkdir -p "$prof/chrome"                  # ensure chrome folder
      ${pkgs.curl}/bin/curl -fsSL \
        https://raw.githubusercontent.com/AKYlU/Firafox_UI/main/Default--Release/userChrome.css \
        -o "$prof/chrome/userChrome.css"       # download stylesheet
    done
  '';
};

system.activationScripts.wayfireConfig = {
  text = ''
    #!/usr/bin/env bash

    user_home="/home/akyil"  # caminho absoluto do usuário

    # Criação do diretório de configuração se não existir
    mkdir -p "$user_home/.config"  # garante que ~/.config existe

    # Baixa o arquivo wayfire.ini diretamente para ~/.config/
    ${pkgs.curl}/bin/curl -fsSL \
      https://raw.githubusercontent.com/AKYlU/Window_Manager/main/Wayfire/Config/wayfire.ini \
      -o "$user_home/.config/wayfire.ini"  # destino do arquivo
  '';
};

 services.journald = {
  storage = "none";  # Desativa armazenamento persistente e volátil
};

   services.getty.autologinUser = "akyil";   # Autologin em tty1

  #systemd.services.wayfire-session = {
  #  description = "Wayfire autostart on tty1";  
  #  after = [ "getty@tty1.service" ];
  #  wantedBy = [ "multi-user.target" ];

  #  serviceConfig = {
  #    # ExecStart    = "${pkgs.wayfire}/bin/wayfire"; # Correct path via pkgs
  #    User         = "akyil";                        # Run as user
   #   TTYPath      = "/dev/tty1";                    # On console 1
  #    StandardInput  = "tty";                        # Attach stdin
   #   StandardOutput = "journal";                    # Log to journal
  #    Restart      = "always";                       # Auto-restart on crash
   # };
 # };

# Desativa a espera por rede online no boot
systemd.network.wait-online.enable = false;

# Desativa sincronização de horário (útil em desktop offline)
services.timesyncd.enable = false;

# Desativa o firewall (se não for necessário)
networking.firewall.enable = false;

#security.polkit.enable = false;

# programs.gamemode.enable = true;

# Ative configurações sysctl persistentes via Nix
boot.kernel.sysctl."vm.swappiness" = 0; # Define o nível de uso da swap

#  zramSwap = {
 #  enable = true;
 #   memoryPercent = 25;
 # };


  # services.dbus.enable = true;

#  services.keyd = {
#    enable = true;
#    keyboards.default = {
#      settings = {
#        main = {
#        m5 = "m4";         # Tecla física 'a' envia 'b'
#        M5 = "M4";         # Tecla física 'b' envia 'a'
#         # capslock = "esc";  # Caps Lock vira Escape
#        };
#      };
#    };
#  };

# boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
#  configfile = ./custom-kernel/config-6.6.91;
# });

# services.nginx = {
 #   enable = true;
#
 #   virtualHosts."_" = {
  #    listen = [{
   #     addr = "0.0.0.0";  # Escuta em todas interfaces
    #    port = 8080;       # Porta 8080
     # }];
     # root = "/var/www/html";  # Local onde copiamos o index.html
     # locations."/" = {
      #  index = "index.html";  # Arquivo principal
      #};
    #};
  #};

#  programs.dconf.enable = true;      # Ativa o backend dconf no sistema para easyeffects

   hardware.graphics = {              # Configurações de GPU para steam
    enable = true;                   # Habilita drivers gráficos
    enable32Bit = true;   
   };

  fonts = {                          # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
#    fontconfig = {
#      enable = true;                 # Habilita fontconfig
#      antialias = true;              # Habilitação de antialias
#      hinting.enable = true;         # Habilita hinting
  #    subpixel.rgba = "rgb";         # Subpixel rendering RGB
#   };
 };

 programs.java = {                  # Configuração do Java
    enable = true;
    package = pkgs.jdk21;            # Define pacote JDK21
   };

# environment.sessionVariables = {   # Variáveis de ambiente para sessões
#     QT_QPA_PLATFORM = "wayland";     # Define plataforma Qt para Wayland
#    QT_QPA_PLATFORMTHEME = "qt5ct";
#    QT_STYLE_OVERRIDE = "Fusion";    # Força estilo Fusion no Qt
#     GTK_THEME = "rose-pine-moon";      # Tema GTK Adwaita escuro
# };

  services.avahi.enable = false;         # Desative se não precisar de descoberta de rede local
  services.openssh.enable = false;       # Só ative se realmente for usar acesso remoto
  services.printing.enable = false;      # Desative se não tiver impressora


  system.stateVersion = "25.05";     # Versão do estado do sistema para atualizações
}

