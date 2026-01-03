{
	description = "NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		mango = {
			url = "github:DreamMaoMao/mango";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		noctalia = {
			url = "github:noctalia-dev/noctalia-shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		quickshell = {
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, mango, noctalia, quickshell, ... }@inputs:

	{
		nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };

			modules = [
				./hosts/laptop/configuration.nix
				
				# Mango system module
				mango.nixosModules.mango
				./modules/system/mango.nix

				# Noctalia system module
				./modules/system/noctalia.nix

			home-manager.nixosModules.home-manager
			{
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.backupFileExtension = "backup";
				home-manager.users.rms = {
					imports = [
						mango.hmModules.mango
						./home/rms/home.nix
						./home/rms/mango.nix
						noctalia.homeModules.default
						./home/rms/noctalia-home.nix
					];
				};	
			}			];
		};
	};
}
