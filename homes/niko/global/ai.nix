{ pkgs, inputs, ... }:
{
  home = {
    packages = with pkgs; [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.plannotator
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
      inputs.llm-tools.packages.${pkgs.stdenv.hostPlatform.system}.next-browser
      ast-grep
      python3
      gh
    ];
    sessionVariables = {
      OPENCODE_ENABLE_EXA = "1";
      OPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECT = "1";
    };
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
        claude = "pnpx @anthropic-ai/claude-code@latest";
        popencode = "pnpx opencode-ai@latest";
        codex = "pnpx @openai/codex";
        skills = "npx skills --agent universal --yes";
      };
    };
  };
}
