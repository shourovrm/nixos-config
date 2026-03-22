{
  description = "rms NixOS system configuration";

  inputs = {
    # NixOS unstable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager — unstable (follows nixpkgs master)
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # share nixpkgs, avoid duplicate downloads
    };

    # Add opencode flake
    opencode-flake = {
      url = "github:aodhanhayter/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";  # share nixpkgs to avoid duplicates
    };


  };

  outputs = { self, nixpkgs, home-manager, opencode-flake, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.rms = import ./home/rms/home.nix;
            # pass opencode into home-manager's pkgs scope
            home-manager.extraSpecialArgs = {
              opencode = opencode-flake.packages.${system}.default;
            };
          }
        ];
      };
    };
}
