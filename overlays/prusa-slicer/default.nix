final: prev: {
  prusa-slicer = prev.stdenv.mkDerivation rec {
    inherit (prev.prusa-slicer) pname version meta;

    src = prev.prusa-slicer;

    nativeBuildInputs = with prev; [ makeWrapper ];

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out

      wrapProgram $out/bin/prusa-slicer \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 0 \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 0
    '';
  };
}
