{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # elephant.url = "github:abenz1267/elephant";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # walker = {
    #   url = "github:abenz1267/walker";
    #   inputs.elephant.follows = "elephant";
    # };
  };

  outputs = { nixpkgs, home-manager, ...} @ inputs : {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.gaugusto = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
