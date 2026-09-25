{ pkgs, ... }:
{
  imports = [ ./dev/vscode.nix ];
  home = {
    packages = with pkgs; [
      slack
      teams-for-linux
      chromium
      devenv
      corepack_24
      nodejs_24
    ];
  };
  xdg.desktopEntries = {
    linear = {
      name = "Linear";
      exec = "chromium --app=https://linear.app";
    };
  };
}
