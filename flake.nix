{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    devShells.x86_64-linux.default = with nixpkgs.legacyPackages.x86_64-linux;
      let
        runScript = writeScriptBin "run.sh" ''
          #!/usr/bin/env bash

          set -euo pipefail

          cat channels.txt |
            parallel --line-buffer -n1 -j1 -I{} yt-dlp --retries 50 --retry-sleep exp=1:64 --dump-json "{}" |
            jq -c 'delpaths([["formats"],["thumbnails"],["automatic_captions"],["subtitles"]])' |
            tee content.json |
            pv -betlapf -i 30 > /dev/null
        '';
      in mkShell { buildInputs = [ yt-dlp parallel runScript git-lfs pv jq ]; };
  };
}
