{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    devShells.x86_64-linux.default = with nixpkgs.legacyPackages.x86_64-linux;
      let
        runScript = writeScriptBin "run.sh" ''
          #!/usr/bin/env bash

          set -euo pipefail

          cat channels.txt |
            parallel --line-buffer -n1 -j 10 -I{} yt-dlp --dump-json "{}" |
            tee content.json |
            while read l; do echo '.'; done
        '';
      in mkShell { buildInputs = [ yt-dlp parallel runScript ]; };
  };
}
