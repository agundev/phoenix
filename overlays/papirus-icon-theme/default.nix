final: prev: {
  papirus-icon-theme = prev.papirus-icon-theme.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      ${prev.gnused}/bin/sed -i '816,9999d' */index.theme
    '';
  });
}
