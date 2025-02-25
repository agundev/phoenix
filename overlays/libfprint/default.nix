self: super: {
  libfprint = super.libfprint.overrideAttrs (oldAttrs: {
    version = "1.94.7-elanmoc2";
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "depau";
      repo = "libfprint";
      rev = "refs/heads/elanmoc2";
      sha256 = "sha256-aLvt04SPjeqsGMWh4hpwGJnrV2zWWMPUePiysM6921g=";
    };
  });

  libfprint-grosshack = super.stdenv.mkDerivation rec {
    pname = "libfprint-grosshack";
    version = "0.3.0";
    src = super.fetchFromGitLab {
      owner = "mishakmak";
      repo = "pam-fprint-grosshack";
      tag = "v${version}";
      sha256 = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
    };

    nativeBuildInputs = with super; [
      pkg-config
      meson
      ninja
      python3
      libpam-wrapper
    ];
    buildInputs = with super; [
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
