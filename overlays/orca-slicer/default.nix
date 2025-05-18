final: prev: {
  orca-slicer = prev.stdenv.mkDerivation rec {
    inherit (prev.orca-slicer) pname version meta;

    src = prev.orca-slicer;

    nativeBuildInputs = with prev; [ makeBinaryWrapper ];

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out

      makeWrapper $out/bin/.orca-slicer-wrapped $out/bin/orca-slicer \
        --inherit-argv0 \
        --prefix LD_LIBRARY_PATH : "$out/lib:${
          prev.lib.makeLibraryPath [
            prev.glew
          ]
        }" 
    '';
  };
}
