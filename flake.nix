{
  description = "Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    # Local dev checkout of typst-preview.nvim (native webview branch).
    # Machine-specific: adjust for the NixOS PC or use the released plugin.
    typst-preview = {
      url = "path:/home/simon/dev/typst-preview.nvim";
      flake = false;
    };

    pdf-extract-cli.url = "github:404Simon/pdf-extract-cli";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      typst-preview,
      pdf-extract-cli,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."simon" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit nixpkgs pkgs-unstable nixvim typst-preview;
          pdf-extract = pdf-extract-cli.packages.${system}.default;
        };

        modules = [
          ./home.nix
        ];
      };

      # Reusable nixvim module set for the future NixOS PC:
      #   programs.nixvim.imports = [ (inputs.nix-config + "/nixvim") ];
      nixvimModule = ./nixvim;
    };
}
