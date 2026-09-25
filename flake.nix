{
  description = "Niko's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    llm-tools.url = "github:mostperfectdev/llm-tools.nix";
    mcp-nixos.url = "github:utensils/mcp-nixos";
  };

  outputs =
    {
      home-manager,
      nixos-hardware,
      nixpkgs,
      mcp-nixos,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = import ./lib {
        inherit
          nixpkgs
          home-manager
          nixos-hardware
          inputs
          ;
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = [
          mcp-nixos.packages.${system}.mcp-nixos
        ];
      };

      nixosConfigurations = {
        gom = lib.mkSystem "gom" {
          hardwareModule = nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4;
        };
        boldan = lib.mkSystem "boldan" { };
        barlow = lib.mkSystem "barlow" { };
      };

      homeConfigurations = {
        "niko@gom" = lib.mkHome {
          hostname = "gom";
          username = "niko";
        };
        "niko@boldan" = lib.mkHome {
          hostname = "boldan";
          username = "niko";
        };
        "niko@barlow" = lib.mkHome {
          hostname = "barlow";
          username = "niko";
        };
      };
    };
}
