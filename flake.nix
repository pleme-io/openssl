{
  description = "Go bindings for OpenSSL via CGo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    substrate = {
      url = "github:pleme-io/substrate";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, substrate, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      mkGoLibraryCheck = (import "${substrate}/lib/go-library-check.nix").mkGoLibraryCheck;
    in {
      # NOTE: build requires OpenSSL with FIPS module (FIPS_mode/FIPS_mode_set symbols).
      # nixpkgs openssl does not enable FIPS by default — this check will fail until
      # a FIPS-enabled OpenSSL derivation is provided via extraAttrs.buildInputs.
      checks.default = mkGoLibraryCheck pkgs {
        pname = "openssl";
        version = "0.0.0-dev";
        src = self;
        proxyVendor = true;
        vendorHash = "sha256-8eifjVMx/VN+Ou7/R9irtpvoJ2mFUzLfB7NeNrue41A=";
        extraAttrs = {
          buildInputs = [ pkgs.openssl ];
          nativeBuildInputs = [ pkgs.pkg-config ];
        };
      };

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [ go gopls gotools openssl ];
      };
    });
}
