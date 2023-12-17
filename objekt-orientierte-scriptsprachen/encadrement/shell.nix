{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python310
    python310Packages.pip
    python310Packages.pygobject3
    python310Packages.pycairo
    python310Packages.pillow
    python310Packages.tkinter
    python310Packages.packaging
    python310Packages.poetry-core
    cairo
    gmp
    gtk3
    glib
    pcre2
    libffi
    pixman
    fontconfig
    freetype
    zlib
    bzip2
    libpng
    brotli
    expat
    gobject-introspection
    gsettings-desktop-schemas
  ];

  shellHook = with pkgs; ''
    #glib-compile-schemas ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas

    export PYTHONPATH=$PYTHONPATH:${python310Packages.pip}/lib/python3.10/site-packages
    export PKG_CONFIG_PATH=${cairo.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${glib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${pcre2.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${libffi.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${pixman}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${fontconfig.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${freetype.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${zlib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${bzip2.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${libpng.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${brotli.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${expat.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${gtk3.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
    export PKG_CONFIG_PATH=${gobject-introspection.dev}/lib/pkgconfig:$PKG_CONFIG_PATH

    export DYLIB_LIBRARY_PATH=${glib.out}/lib:$DYLIB_LIBRARY_PATH

    export GIO_EXTRA_MODULES=${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share:$XDG_DATA_DIRS
    export GSETTINGS_SCHEMA_DIR=${gsettings-desktop-schemas}/share
  '';
}
