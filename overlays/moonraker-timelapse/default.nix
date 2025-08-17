final: prev: {
  # Thanks to gradientvera for the initial derivation
  # Code stolen from https://github.com/gradientvera/GradientOS/blob/main/pkgs/moonraker-timelapse.nix
  moonraker-timelapse = prev.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "moonraker-timelapse";
    version = "v0.0.1-c7fff11";

    src = prev.fetchFromGitHub {
      owner = "mainsail-crew";
      repo = finalAttrs.pname;
      rev = "c7fff11e542b95e0e15b8bb1443cea8159ac0274";
      sha256 = "sha256-ZYSeSn3OTManyTbNOnCfhormjFMgomNk3VXOVqBr9zg=";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out/lib/${finalAttrs.pname}
      cp -r ./* $out/lib/${finalAttrs.pname}/
    '';

    passthru.moonrakerOverrideAttrs =
      let
        pkg = finalAttrs.finalPackage;
      in
      (prevAttrs: {
        installPhase = (prevAttrs.installPhase or "") + ''
          cp ${pkg}/lib/${finalAttrs.pname}/component/timelapse.py $out/lib/moonraker/components/timelapse.py
        '';
      });

    passthru.macroFile = "${finalAttrs.finalPackage}/lib/${finalAttrs.pname}/klipper_macro/timelapse.cfg";
  });

  moonraker = prev.moonraker.overrideAttrs final.moonraker-timelapse.moonrakerOverrideAttrs;
}
