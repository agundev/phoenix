final: prev: {
  klipperscreen = prev.klipperscreen.overridePythonAttrs (old: {
    postPatch = ''
      mkdir -p styles/modern
      cp -r styles/material-dark/images styles/modern
      cp ${./style.css} styles/modern/style.css
    '';
  });
}
