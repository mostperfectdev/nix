{ pkgs, inputs, ... }:
{
  home = {
    packages = with pkgs; [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
      python3
      gh
    ];
  };

  programs = {
    git.ignores = [
      ".opencode"
      "AGENTS.md"
      ".agents"
      "skills-lock.json"
    ];

    fish = {
      shellAbbrs = {
        oc = "opencode";
      };

      shellAliases = {
        opencode = "opencode2";
      };
    };
  };
}
