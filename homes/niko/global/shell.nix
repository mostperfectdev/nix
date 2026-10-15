{ pkgs, ... }:
{
  imports = [
    ./shell/fish.nix
    ./ai.nix
  ];

  home.packages = with pkgs; [
    wget
    nixd
    nixfmt
    dust
    comma
    zellij
  ];

  programs = {
    keychain = {
      enable = true;
      enableFishIntegration = false;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Niko";
          email = "git@undefine.dev";
        };
        core.excludesFile = "~/.config/git/ignore";
        column.ui = "auto";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        init.defaultBranch = "main";
        diff = {
          algorithm = "histogram";
          mnemonicPrefix = true;
          rename = true;
        };
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        rebase = {
          updateRefs = true;
        };
        help.autocorrect = true;
        pull.rebase = true;
      };
    };
    mergiraf = {
      enable = true;
      enableGitIntegration = true;
    };
    gitui = {
      enable = true;
    };
    nh = {
      enable = true;
      flake = "/home/niko/nix";
      clean.enable = true;
    };
    ripgrep.enable = true;
    fd.enable = true;
    bat.enable = true;
  };
}
