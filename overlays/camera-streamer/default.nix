final: prev:
let
  # We have to use this workaround until trixie support is merged
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c407032be28ca2236f45c49cfb2b8b3885294f7f.tar.gz";
    sha256 = "1a95d5g5frzgbywpq7z0az8ap99fljqk3pkm296asrvns8qcv5bv";
  }) {
    system = prev.stdenv.system;
    config = prev.config;
  };
in {
  # Thanks to Electrostasy for the initial derivation
  # Code stolen from https://github.com/Electrostasy/dots/blob/master/pkgs/camera-streamer.nix
  camera-streamer = oldPkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "camera-streamer";
    version = "0.3.0";

    src = prev.fetchFromGitHub {
      owner = "ayufan";
      repo = "camera-streamer";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-xKSQdD2I/naMAoSqoGraYrWnNCbOrz2Bou7AqbuGlJM=";
      fetchSubmodules = true;
      leaveDotGit = true;
    };

    # Second replacement fixes literal newline in generated version.h.
    postPatch = ''
      substituteInPlace Makefile \
        --replace '/usr/local/bin' '/bin' \
        --replace 'echo "#define' 'echo -e "#define'
    '';

    env.NIX_CFLAGS_COMPILE = builtins.toString [
      "-Wno-error=stringop-overflow"
      "-Wno-error=format"
      "-Wno-format"
      "-Wno-format-security"
      "-Wno-error=unused-result"
    ];

    nativeBuildInputs = with oldPkgs; [
      cmake
      gnumake
      pkg-config
      xxd
      which
      git
    ];

    dontUseCmakeConfigure = true;

    # All optional features enabled
    buildInputs = with oldPkgs; [ nlohmann_json v4l-utils ffmpeg libcamera live555 openssl ];

    installFlags = [ "DESTDIR=${builtins.placeholder "out"}" ];
    preInstall = "mkdir -p $out/bin";

    meta = with prev.lib; {
      description = "High-performance low-latency camera streamer for Raspberry Pi's";
      website = "https://github.com/ayufan/camera-streamer";
      license = licenses.gpl3Only;
    };
  });
}
