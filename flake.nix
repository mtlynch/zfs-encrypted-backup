{
  description = "Dev environment for zfs-encrypted-backup";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # 0.9.0 release
    shellcheck_dep.url = "github:NixOS/nixpkgs/8b5ab8341e33322e5b66fb46ce23d724050f6606";
  };

  outputs = { self, flake-utils, shellcheck_dep }@inputs :
    flake-utils.lib.eachDefaultSystem (system:
    let
      shellcheck_dep = inputs.shellcheck_dep.legacyPackages.${system};
    in
    {
      devShells.default = shellcheck_dep.mkShell {
        packages = [
          shellcheck_dep.shellcheck
        ];

        shellHook = ''
          echo "shellcheck" "$(shellcheck --version | grep '^version:')"
        '';
      };
    });
}
