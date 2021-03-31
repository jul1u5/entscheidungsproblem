{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs) lib;
        pkgs = import nixpkgs { inherit system; };

        pname = "entscheidungsproblem";

        haskellPackages = pkgs.haskellPackages.extend (pkgs.haskell.lib.packageSourceOverrides {
          "${pname}" = self;
        });
      in
      {
        packages.${pname} = haskellPackages.${pname};

        defaultPackage = self.packages.${pname};

        devShell = haskellPackages.shellFor {
          packages = p: [ p.${pname} ];
          withHoogle = true;
          buildInputs = lib.attrValues {
            inherit (pkgs)
              cabal-install
              hlint
              ;

            inherit (pkgs.haskellPackages)
              haskell-language-server
              pretty-simple
              fourmolu
              ;
          };
        };
      }
    );
}
