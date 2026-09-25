# Desktop environment (Niri, Noctalia, etc)
{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./desktop/niri.nix
    ./desktop/applications.nix
  ];

  home = {
    packages = with pkgs; [
      pavucontrol
      pamixer
      lxqt.lxqt-policykit
      wl-clipboard
      xdg-utils
      firefox
      pywalfox-native
      seahorse
      dconf
      grim
      slurp
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      playerctl
      sptlrx
    ];
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };
  };

  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Geist" ];
      serif = [ "Geist" ];
      monospace = [ "VictorMono NF SemiBold" ];
      emoji = [ "Noto Color Emoji" ];
    };
    enable = true;
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      plugins.enabled = [ "niko/power-heat" ];
      system.monitor.enabled = true;

      shell = {
        font_family = "VictorMono NF";
        avatar_path = "${config.home.homeDirectory}/.face";
        corner_radius_scale = 0.8;
        password_style = "random";
        niri_overview_type_to_launch_enabled = true;
        launch_apps_as_systemd_services = true;

        panel = {
          transparency_mode = "soft";
          control_center_placement = "floating";
        };

        screen_corners.enabled = true;
      };

      wallpaper = {
        directory = "~/Pictures/gowall";
        transition = [
          "fade"
          "wipe"
        ];
      };

      theme = {
        builtin = "Kanagawa";

        templates.builtin_ids = [
          "ghostty"
          "zed"
          "pywalfox"
          "zenBrowser"
          "code"
        ];
      };

      backdrop = {
        enabled = true;
        blur_intensity = 0.09;
      };

      lockscreen = {
        blurred_desktop = true;
        blur_intensity = 0.28;
        tint_intensity = 0.15;
      };

      osd.position = "bottom_center";

      idle = {
        pre_action_fade_seconds = 2.0;

        behavior.lock = {
          timeout = 600;
          command = "brightnessctl -s set 25% && noctalia msg session lock";
          resume_command = "brightnessctl -r";
          enabled = true;
        };

        behavior.screen-off = {
          timeout = 660;
          command = "noctalia:dpms-off";
          resume_command = "noctalia:dpms-on";
          enabled = true;
        };

        behavior.suspend = {
          timeout = 900;
          command = "[ \"$(cat /sys/class/power_supply/AC/online 2>/dev/null)\" = \"0\" ] && systemctl suspend";
          resume_command = "";
          enabled = true;
        };
      };

      bar.main = {
        scale = 1.15;
        start = [
          "workspaces"
          "active-window"
          "media"
        ];
        end = [
          "control-center"
          "tray"
          "sysmon_cpu"
          "sysmon_mem"
          "power_heat"
          "notifications"
          "battery"
          "volume"
        ];
      };

      dock = {
        enabled = true;
        background_opacity = 0.66;
        launcher_position = "start";
        auto_hide = true;
        reserve_space = false;
      };

      desktop_widgets.enabled = true;

      control_center = {
        sidebar = "compact";
        sidebar_section = "compact";

        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "nightlight"; }
          { type = "nightlight_disabled"; }
          { type = "keyboard"; }
          { type = "battery"; }
          { type = "battery_time"; }
          { type = "screenRecorder"; }
          { type = "screenRecorderTimer"; }
          { type = "volume"; }
          { type = "brightness"; }
          { type = "media"; }
        ];
      };

      weather.enabled = true;

      widget.clock.format = "{:%H:%M}";
      widget.workspaces = {
        display = "id";
        max_label_chars = 2;
        labels_only_when_occupied = true;
      };
      widget.active_window = {
        min_length = 80;
        max_length = 240;
        icon_size = 20;
        title_scroll = "on_hover";
      };
      widget.media = {
        max_length = 145;
        art_size = 28;
        hide_when_no_media = false;
      };
      widget.sysmon_cpu = {
        type = "sysmon";
        stat = "cpu_usage";
        display = "gauge";
        show_label = true;
      };
      widget.sysmon_mem = {
        type = "sysmon";
        stat = "ram_pct";
        display = "gauge";
        show_label = true;
      };
      widget.power_heat.type = "niko/power-heat:power_heat";
      widget.control-center = {
        custom_image = "noctalia";
        custom_image_colorize = true;
      };
    };
  };

  services = {
    kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          output.criteria = "eDP-1";
          output.scale = 1.5;
        }
        {
          profile.name = "default";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "office";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
              mode = "1920x1200";
              scale = 1.5;
              position = "1920,1080";
            }
            {
              criteria = "Samsung Electric Company C27F390 H4ZT800705";
              mode = "1920x1080";
              position = "1920,0";
            }
            {
              criteria = "Samsung Electric Company C27F390 H4ZT800351";
              mode = "1920x1080";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "DP-8";
              mode = "2560x1440";
              position = "2360,480";
              scale = 1.25;
            }
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              scale = 1.5;
              position = "0,1280";
            }
            {
              criteria = "DP-11";
              mode = "1920x1080@60";
              position = "1280,0";
              transform = "90";
            }
          ];
        }
        {
          profile.name = "eizo-above";
          profile.outputs = [
            {
              criteria = "Eizo Nanao Corporation EV2451 72202039";
              mode = "1920x1080";
              position = "0,0";
            }
            {
              criteria = "eDP-1";
              scale = 1.5;
              position = "0,1080";
            }
          ];
        }
        {
          profile = {
            name = "home";
            outputs = [
              {
                criteria = "DP-1";
                mode = "2560x1440";
                position = "1080,480";
                scale = 1.25;
              }
              {
                criteria = "HDMI-A-1";
                mode = "1920x1080";
                position = "3124,800";
              }
              {
                criteria = "DP-2";
                mode = "1920x1080@60";
                position = "0,0";
                transform = "90";
              }
            ];
          };
        }
      ];
    };
    cliphist = {
      enable = true;
    };
  };

  home.file.".local/share/noctalia/plugins/niko-power-heat/plugin.toml".text =
    ''
      id = "niko/power-heat"
      name = "Power and heat"
      version = "1.0.0"
      plugin_api = 23
      author = "niko"
      license = "MIT"
      description = "Shows battery power consumption and CPU temperature."
      tags = ["power", "temperature", "battery"]

      [[widget]]
      id = "power_heat"
      entry = "widget.luau"
    '';
  home.file.".local/share/noctalia/plugins/niko-power-heat/widget.luau".text =
    ''
      local powerWatts = nil
      local temperatureC = nil

      local function readBatteryPower()
          for index = 0, 3 do
              local path = "/sys/class/power_supply/BAT" .. tostring(index) .. "/power_now"
              local raw = noctalia.readFile(path)
              if raw ~= nil then
                  local microwatts = tonumber(raw)
                  if microwatts ~= nil and microwatts > 0 then
                      return microwatts / 1000000
                  end
              end
          end
          return nil
      end

      local function updateValues()
          powerWatts = readBatteryPower()

          local stats = noctalia.systemStats()
          temperatureC = stats and stats.cpu and stats.cpu.tempC or nil
      end

      local function render()
          local power = powerWatts and string.format("%.1f W", powerWatts) or "AC"
          local temperature = temperatureC and string.format("%.0f°C", temperatureC) or "--°C"

          barWidget.setGlyph("temperature")
          barWidget.setText(power .. " · " .. temperature)
          barWidget.setTooltip("Battery power: " .. power .. "\nCPU temperature: " .. temperature)
      end

      function update()
          noctalia.setUpdateInterval(2000)
          updateValues()
          render()
      end
    '';
}
