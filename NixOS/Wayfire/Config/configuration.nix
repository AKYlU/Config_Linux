{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix    # Importa as configurações de hardware geradas automaticamente
  ];
 
  boot.loader.systemd-boot.enable = true;                # Habilita o carregador de sistema systemd-boot

  nixpkgs.config.allowUnfree = true;                      # Permite pacotes com licenças não-livres

  networking.hostName = "wayfire-nixos";                 # Define o nome de host da máquina
  time.timeZone = "America/Sao_Paulo";                   # Define o fuso horário do sistema
  # i18n.defaultLocale = "en_US.UTF-8";                    # Define o locale padrão do sistema
  console.keyMap = "us";                                 # Define o layout de teclado do console

  networking.networkmanager.enable = true;

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

  hardware.pulseaudio.enable = false;                    # Desabilita PulseAudio
  services.pipewire = {                                  # Configura e habilita o PipeWire
    enable = true;
    alsa.enable = true;                                  # Suporte ALSA
    alsa.support32Bit = true;                            # Suporte a bins de 32 bits
    pulse.enable = true;                                 # Habilita compatibilidade PulseAudio
    jack.enable = true;                                  # Habilita compatibilidade JACK
  };

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

   services.getty.autologinUser = "akyil";   # Autologin em tty1

# Desativa a espera por rede online no boot
systemd.network.wait-online.enable = false;

# Desativa sincronização de horário (útil em desktop offline)
services.timesyncd.enable = false;

# Desativa o firewall (se não for necessário)
networking.firewall.enable = false;

#security.polkit.enable = false;

# Ative configurações sysctl persistentes via Nix
boot.kernel.sysctl."vm.swappiness" = 0; # Define o nível de uso da swap

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

   hardware.graphics = {              # Configurações de GPU para steam
    enable = true;                   # Habilita drivers gráficos
    enable32Bit = true;   
   };

  fonts = {                          # Configuração de fontes e fontconfig
    enableDefaultPackages = true;
 };

 programs.java = {                  # Configuração do Java
    enable = true;
    package = pkgs.jdk21;            # Define pacote JDK21
   };

  services.avahi.enable = false;         # Desative se não precisar de descoberta de rede local
  services.openssh.enable = false;       # Só ative se realmente for usar acesso remoto
  services.printing.enable = false;      # Desative se não tiver impressora

   services.journald = {
  storage = "none";  # Desativa armazenamento persistente e volátil
};

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

  system.activationScripts.lvimConfig = {
    text = ''
      #!/usr/bin/env bash
      mkdir -p /home/akyil/.config/lvim

      cat > /home/akyil/.config/lvim/config.lua << 'EOF'
lvim.autocommands = {
  {
    "ColorScheme",
    {
      pattern = "*",
      callback = function()
        local transparent_groups = {
          "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "VertSplit",
          "StatusLine", "TabLine", "TabLineFill", "TabLineSel", "Pmenu",
          "PmenuSel", "WinSeparator", "FloatBorder", "MsgArea", "CursorLineNr",
          "LineNr", "Folded", "NormalFloat", "TelescopeNormal", "TelescopeBorder",
          "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NvimTreeVertSplit"
        }

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "NONE" }) -- background transparency
        end
      end,
    },
  },
}
EOF

      chown -R akyil:akyil /home/akyil/.config/lvim
    '';
  };

# Abri o Wayfire
  system.activationScripts.setupWayfireFish = {
    text = ''
      #!/usr/bin/env bash
      mkdir -p /home/akyil/.config/fish

      cat > /home/akyil/.config/fish/config.fish << 'EOF'
if test -z "\$DISPLAY"; and test (tty) = "/dev/tty1"
    exec wayfire
end
EOF

      chown -R akyil:akyil /home/akyil/.config/fish
    '';
  };

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
      mkdir -p /home/akyil/.config

      cat > /home/akyil/.config/wayfire.ini << 'EOF'
[alpha]
min_value = 0.040000
modifier = <super> KEY_2

[animate]
close_animation = zoom
duration = 400ms circle
enabled_for = (type equals "toplevel" | (type equals "x-or" & focusable equals true))
fade_duration = 400ms circle
fade_enabled_for = type equals "overlay"
fire_color = \#B22303FF
fire_duration = 300ms linear
fire_enabled_for = none
fire_particle_size = 16.000000
fire_particles = 2000
open_animation = zoom
random_fire_color = false
startup_duration = 600ms linear
zoom_duration = 500ms circle
zoom_enabled_for = none

[autostart]
0_env = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
# Status = premid --no-sandbox --disable-gpu --disable-software-rasterizer
autostart_wf_shell = false
browser = librewolf 
colar = wl-paste --watch xclip -selection clipboard
gamma = wlsunset -T 3001 -t 3000 -S 00:01 -s 00:02
portal = /usr/libexec/xdg-desktop-portal-wlr
# wallpepar = mpvpaper -o "--loop --no-audio" "*" ~/Downloads/wallpaper/FundoGril0000-0901.mp4

[blur]
blur_by_default = type is "toplevel"
bokeh_degrade = 1
bokeh_iterations = 15
bokeh_offset = 5.000000
box_degrade = 1
box_iterations = 2
box_offset = 1.000000
enabled = true
gaussian_degrade = 1
gaussian_iterations = 2
gaussian_offset = 1.000000
kawase_degrade = 3
kawase_iterations = 2
kawase_offset = 1.700000
method = kawase
saturation = 1.000000
strength = 10
toggle = none

[command]
binding_0 = <super> KEY_N
binding_1 = <super> KEY_C
binding_2 = <super> KEY_O
binding_TextoImagem = <super> KEY_1
binding_UTAU = <super> KEY_L
binding_blender = <super> KEY_B
binding_boxes = <super> KEY_G
binding_file = <super> KEY_E
binding_lower_volume = KEY_VOLUMEDOWN
binding_next = <super> KEY_A
binding_playerctl = <super> KEY_Q
binding_previous = <super> KEY_Z
binding_prismlauncher = <super> KEY_M
binding_raise_volume = KEY_VOLUMEUP
binding_reaper = <super> KEY_P
binding_screenshot_interactive = KEY_PAUSE
binding_steam = <super> KEY_S
binding_terminal = <super> KEY_ENTER
binding_unity = <super> KEY_U
binding_virt-manager = <super> KEY_V
command_0 = firefox-esr
command_1 = wcm
command_2 = obs
command_TextoImagem = bash -c '/home/akyil/capture_and_ocr.sh'
command_UTAU = OpenUtau
command_blender = blender
command_boxes = gnome-boxes
command_file = nemo
command_lower_volume = pactl set-sink-volume @DEFAULT_SINK@ -8%
command_next = playerctl next
command_playerctl = playerctl play-pause
command_previous = playerctl previous
command_prismlauncher = prismlauncher
command_raise_volume = pactl set-sink-volume @DEFAULT_SINK@ +8%
command_reaper = reaper
command_screenshot_interactive = slurp | tee /tmp/region | grim -g - ~/Downloads/Img/$(date '+%F_%T').png && grim -g "$(cat /tmp/region)" - | wl-copy
command_steam = steam
command_terminal = kitty --override background_opacity=0.3
command_unity = unityhub
command_virt-manager = virt-manager

[core]
background_color = \#4D2969FF
close_top_view = <super> KEY_W | <alt> KEY_F4
focus_button_with_modifiers = false
focus_buttons = BTN_LEFT | BTN_MIDDLE | BTN_RIGHT
focus_buttons_passthrough = true
max_render_time = -1
plugins = expo resize command autostart wm-actions scale zoom move
preferred_decoration_mode = server
transaction_timeout = 100
vheight = 2
vwidth = 2
xwayland = lazy

[cube]
activate = <alt> <ctrl> BTN_LEFT
background = \#1A1A1AFF
background_mode = simple
cubemap_image = 
deform = 0
initial_animation = 350ms circle
light = true
rotate_left = none
rotate_right = none
skydome_mirror = true
skydome_texture = 
speed_spin_horiz = 0.020000
speed_spin_vert = 0.020000
speed_zoom = 0.070000
zoom = 0.100000

[decoration]
active_color = \#DC8ADDFF
border_size = 4
button_order = minimize maximize close
font = sans-serif
ignore_views = none
inactive_color = \#333333DD
title_height = 30

[expo]
background = \#1A1A1AFF
duration = 0ms linear
inactive_brightness = 0.700000
keyboard_interaction = false
offset = 0
select_workspace_1 = KEY_1
select_workspace_2 = KEY_2
select_workspace_3 = KEY_3
select_workspace_4 = KEY_4
select_workspace_5 = KEY_5
select_workspace_6 = KEY_6
select_workspace_7 = KEY_7
select_workspace_8 = KEY_8
select_workspace_9 = KEY_9
toggle = <super> KEY_GRAVE
transition_length = 0

[extra-gestures]
close_fingers = 20
move_delay = 500
move_fingers = 3

[fast-switcher]
activate = <alt> KEY_ESC
activate_backward = <alt> <shift> KEY_ESC
inactive_alpha = 0.700000

[fisheye]
radius = 270.000000
toggle = <ctrl> <super> KEY_F
zoom = 8.000000

[focus-request]
allow_unfocused_open = true

[foreign-toplevel]

[grid]
duration = 0ms linear
restore = <super> KEY_DOWN | <super> KEY_KP0
slot_b = <super> KEY_KP2
slot_bl = <super> KEY_KP1
slot_br = <super> KEY_KP3
slot_c = <super> KEY_UP | <super> KEY_KP5
slot_l = <super> KEY_LEFT | <super> KEY_KP4
slot_r = <super> KEY_RIGHT | <super> KEY_KP6
slot_t = <super> KEY_KP8
slot_tl = <super> KEY_KP7
slot_tr = <super> KEY_KP9
type = none

[gtk-shell]

[idle]
cube_max_zoom = 1.500000
cube_rotate_speed = 1.000000
cube_zoom_speed = 1000
disable_initially = true
disable_on_fullscreen = true
dpms_timeout = -1
screensaver_timeout = 3600
toggle = <super> KEY_6

[input]
click_method = default
cursor_size = 24
cursor_theme = default
disable_touchpad_while_mouse = false
disable_touchpad_while_typing = false
drag_lock = false
gesture_sensitivity = 1.000000
kb_capslock_default_state = false
kb_numlock_default_state = false
kb_repeat_delay = 400
kb_repeat_rate = 40
left_handed_mode = false
middle_emulation = false
modifier_binding_timeout = 400
mouse_accel_profile = flat
mouse_cursor_speed = 0.000000
mouse_natural_scroll = false
mouse_scroll_speed = 1.000000
natural_scroll = false
scroll_method = default
tablet_motion_mode = default
tap_to_click = true
touchpad_accel_profile = default
touchpad_cursor_speed = 0.000000
touchpad_scroll_speed = 1.000000
xkb_layout = us
xkb_model = 
xkb_options = 
xkb_rules = evdev
xkb_variant = 

[input-device]
output = 

[input-method-v1]
enable_text_input_v1 = true
enable_text_input_v3 = true

[invert]
preserve_hue = true
toggle = <super> KEY_I

[ipc]

[ipc-rules]

[keybindings]
tile_toggle = <super> KEY_T

[move]
activate = <super> BTN_LEFT
enable_snap = false
enable_snap_off = false
join_views = false
preview_base_border = \#404080CC
preview_base_color = \#8080FF80
preview_border_width = 3
quarter_snap_threshold = 50
snap_off_threshold = 10
snap_threshold = 10
workspace_switch_after = -1

[oswitch]
next_output = <super> KEY_O
next_output_with_win = <shift> <super> KEY_O
prev_output = 
prev_output_with_win = 

[output]
depth = 8
mode = auto
position = auto
scale = 1.000000
transform = normal
vrr = false

[output:HDMI-A-1]
depth = 8
mode = auto
position = auto
scale = 1.000000
transform = normal
vrr = false

[place]
mode = random

[plugin/tile]
enabled = true

[preserve-output]
last_output_focus_timeout = 10000

[resize]
activate = <super> BTN_RIGHT
activate_preserve_aspect = none

[scale]
allow_zoom = true
bg_color = \#1A1A1AE6
close_on_new_view = true
duration = 0ms linear
inactive_alpha = 0.750000
include_minimized = true
middle_click_close = true
minimized_alpha = 0.450000
outer_margin = 0
spacing = 50
text_color = \#CCCCCCFF
title_font_size = 16
title_overlay = all
title_position = center
toggle = <super> KEY_TAB
toggle_all = 

[scale-title-filter]
bg_color = \#00000080
case_sensitive = false
font_size = 30
overlay = true
share_filter = false
text_color = \#CCCCCCCC

[session-lock]

[shortcuts-inhibit]
break_grab = <super> KEY_1
ignore_views = none
inhibit_by_default = none

[simple-tile]
animation_duration = 0ms circle
button_move = <super> BTN_LEFT
button_resize = <super> BTN_RIGHT
inner_gap_size = -10
keep_fullscreen_on_adjacent = false
key_focus_above = <super> KEY_K
key_focus_below = <super> KEY_J
key_focus_left = <super> KEY_H
key_focus_right = <super> KEY_L
key_toggle = <super> KEY_1
outer_horiz_gap_size = -10
outer_vert_gap_size = -5
preview_base_border = \#404080CC
preview_base_color = \#8080FF80
preview_border_width = 3
tile_by_default = all

[switcher]
next_view = <alt> KEY_TAB
prev_view = <alt> <shift> KEY_TAB
speed = 500ms circle
view_thumbnail_rotation = 30
view_thumbnail_scale = 1.000000

[transparency]
enabled = true
opacity = 0.9

[transparency:rules]
class = nemo
enabled = 
opacity = 0.9

[vswipe]
background = \#1A1A1AFF
delta_threshold = 24.000000
duration = 180ms circle
enable_free_movement = true
enable_horizontal = true
enable_smooth_transition = true
enable_vertical = true
fingers = 4
gap = 32.000000
speed_cap = 0.050000
speed_factor = 256.000000
threshold = 0.350000

[vswitch]
background = \#1A1A1AFF
binding_down = 
binding_last = 
binding_left = 
binding_right = 
binding_up = 
duration = 0ms circle
gap = 0
send_win_down = 
send_win_last = 
send_win_left = 
send_win_right = 
send_win_up = 
with_win_down = <super> KEY_S
with_win_last = 
with_win_left = <super> KEY_A
with_win_right = <super> KEY_D
with_win_up = <super> KEY_W
wraparound = false

[wayfire-shell]
toggle_menu = <super> 

[wbg]
background = /dev/null
mode = none

[window-rules]
rule_pip_on_top = on created if title contains "konsole" then set always_on_top
rule_vrchat_floating = on created if app_id is "konsole" then set floating true

[wm-actions]
minimize = <super> KEY_ESC
send_to_back = <super> KEY_SPACE
toggle_always_on_top = <super> KEY_T
toggle_fullscreen = none
toggle_maximize = <super> KEY_F
toggle_showdesktop = none
toggle_sticky = <super> KEY_Y

[wobbly]
friction = 1.000000
grid_resolution = 6
spring_k = 8.000000

[workarounds]
all_dialogs_modal = false
app_id_mode = full
discard_command_output = false
dynamic_repaint_delay = true
enable_input_method_v2 = false
enable_opaque_region_damage_optimizations = true
enable_so_unloading = false
force_preferred_decoration_mode = false
remove_output_limits = false
use_external_output_configuration = false

[wrot]
activate = <ctrl> <super> BTN_RIGHT
activate-3d = <shift> <super> BTN_RIGHT
invert = false
reset = <ctrl> <super> KEY_R
reset-one = <super> KEY_R
reset_radius = 25.000000
sensitivity = 24

[wsets]
label_duration = 2000ms linear

[xdg-activation]

[zoom]
interpolation_method = 0
modifier = <super> 
smoothing_duration = 0ms linear
speed = 0.010000
EOF

      chown -R akyil:akyil /home/akyil/.config
    '';
  };

  system.stateVersion = "25.05";     # Versão do estado do sistema para atualizações
}

