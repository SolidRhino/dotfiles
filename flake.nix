{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    nixvim = {
      url = "github:SolidRhino/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paste-misterio-me = {
      url = "github:misterio77/paste.misterio.me";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    pre-commit-hooks,
    nixvim,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs nixvim;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      # Server vpsfree.cz
      horizon = lib.nixosSystem {
        modules = [./hosts/horizon];
        specialArgs = {
          inherit inputs outputs;
        };
      };

      # Test server vpsfree.cz
      vps-test = lib.nixosSystem {
        modules = [./hosts/vps-test];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    homeConfigurations = {
      # Standalone HM only
      # Server vpsfree.cz
      "ivo@horizon" = lib.homeManagerConfiguration {
        modules = [./home/ivo/horizon.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
