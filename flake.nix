{
  description = "rms NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-flake = {
      url = "github:aodhanhayter/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia shell + its quickshell dependency
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, opencode-flake, noctalia, noctalia-qs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.rms-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/rms-laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs        = true;
            home-manager.useUserPackages      = true;
            home-manager.backupFileExtension  = "backup";
            home-manager.users.rms            = import ./home/rms/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              opencode = opencode-flake.packages.${system}.default;
            };
          }
        ];
      };
    };
}
