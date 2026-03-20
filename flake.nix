{
  description = "rms NixOS system configuration";

  inputs = {
    # NixOS stable channel — matches your stateVersion 25.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager — same release as nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # share nixpkgs, avoid duplicate downloads
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in
    {
      # Build / switch with:
      #   sudo nixos-rebuild switch --flake ~/nixos-config#laptop
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix

          # Wire Home Manager in as a NixOS module so one rebuild does everything
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;  # share system nixpkgs
            home-manager.useUserPackages = true;  # install to /etc/profiles
            home-manager.backupFileExtension = "backup"; # don't error on existing dotfiles
            home-manager.users.rms = import ./home/rms/home.nix;
          }
        ];
      };
    };
}
