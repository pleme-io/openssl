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

  # NOTE: build requires OpenSSL with FIPS module (FIPS_mode/FIPS_mode_set symbols).
  # nixpkgs openssl does not enable FIPS by default.
  outputs = inputs: (import "${inputs.substrate}/lib/repo-flake.nix" {
    inherit (inputs) nixpkgs flake-utils;
  }) {
    self = inputs.self;
    language = "go";
    builder = "library";
    pname = "openssl";
    vendorHash = "sha256-8eifjVMx/VN+Ou7/R9irtpvoJ2mFUzLfB7NeNrue41A=";
    proxyVendor = true;
    cDeps = [ "openssl" ];
    cNativeDeps = [ "pkg-config" ];
    extraDevPackages = [ "openssl" ];
    description = "Go bindings for OpenSSL via CGo";
    homepage = "https://github.com/pleme-io/openssl";
  };
}
