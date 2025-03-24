final: prev: {
  libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
    version = "1.94.9-elanmoc2";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "geodic";
      repo = "libfprint";
      rev = "refs/heads/master";
      sha256 = "sha256-ZHX6nw1MGgrwAqxhe4pvGJ7nU2OM32hubEFA1N7EMBE=";
    };

    buildInputs = with prev; [ nss ] ++ oldAttrs.buildInputs;

    mesonFlags = prev.lib.remove "-Ddrivers=all" oldAttrs.mesonFlags;
  });

  libfprint-grosshack = prev.stdenv.mkDerivation rec {
    pname = "libfprint-grosshack";
    version = "0.3.0";
    src = prev.fetchFromGitLab {
      owner = "mishakmak";
      repo = "pam-fprint-grosshack";
      tag = "v${version}";
      sha256 = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
    };

    nativeBuildInputs = with prev; [
      pkg-config
      meson
      ninja
      python3
      libpam-wrapper
    ];
    buildInputs = with prev; [
      fprintd
      libfprint
      glib
      pam
      polkit
      dbus
      dbus-glib
      systemd
    ];

    mesonFlags = [ "-Dpam_modules_dir=${placeholder "out"}/lib/security" ];
  };
}
