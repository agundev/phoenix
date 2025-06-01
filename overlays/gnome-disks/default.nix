final: prev: {
  gnome-disk-utility = prev.gnome-disk-utility.overrideAttrs (oldAttrs: rec {
    version = "47.alpha";

    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "gnome-disk-utility";
      rev = "main";
      hash = "sha256-Al9ts+l5sCyggRqCavl9GZALk6cWR5nXpBsx9WJG+go=";
    };

    cargoDeps = prev.rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "udisks2-0.1.0" = "sha256-pJT20ATMRq0UYXWNvo85Qe/pMu+pWDNHHgbqu0isS6c=";
      };
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs
      ++ [
        prev.rustc
        prev.cargo
        prev.rustPlatform.cargoSetupHook
      ];

    buildInputs = builtins.filter (p: p != prev.gtk3) oldAttrs.buildInputs
      ++ [
        prev.gtk4
        prev.libadwaita
      ];

    postPatch = (oldAttrs.postPatch or "") + ''
      # Create .cargo/config.toml to point Cargo to the vendored dependencies
      mkdir -p .cargo
      cat > .cargo/config.toml <<EOF
      [source.crates-io]
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "${cargoDeps}"
      EOF
    '';
  });
}
