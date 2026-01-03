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
	};

	outputs = { self, nixpkgs, home-manager, mango, ... }@inputs:

	{
		nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			modules = [
				./hosts/laptop/configuration.nix
				
				# Mango system module
				mango.nixosModules.mango
				./modules/system/mango.nix

				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.rms = {
						imports = [
							mango.hmModules.mango
							./home/rms/home.nix
							./home/rms/mango.nix
						];
					};	
				}
				
			];
		};
	};
}
