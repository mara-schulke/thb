{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python38
    python38Packages.pip
    ffmpeg
  ];

  shellHook = ''
    export PYTHONPATH=$PYTHONPATH:${pkgs.python38Packages.pip}/lib/python3.8/site-packages
  '';

  postShellHook = ''
    python -m venv venv
    source venv/bin/activate
    pip install pydub requests argparse
  '';
}
