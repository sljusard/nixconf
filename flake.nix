{
  description = "SljusarD's fine-tuned NixOS configuraton flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    import-tree.url = "github:vic/import-tree";
    wrappers.url = "github:Lassulus/wrappers";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dvr-patched = {
      url = "git+https://git.sljusard.com/sljusard/dvr-patched-flake.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nvf.url = "github:notashelf/nvf";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
