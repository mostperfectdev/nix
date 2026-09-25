{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        la = "ls -hal";
        ".." = "cd ..";
        "..." = "cd ..";
        "dcud" = "docker compose up -d";
        "dc" = "docker compose";
      };
      interactiveShellInit = ''
        set -e LD_LIBRARY_PATH
        set fish_greeting
        if set -q SSH_CONNECTION
          eval (keychain --eval id_ed25519)
        end
      '';
      plugins = [
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
        { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;
      enableInteractive = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };
  };
  home.packages = with pkgs; [
    docker-credential-helpers
  ];
}
