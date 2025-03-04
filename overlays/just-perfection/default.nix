final: prev: {
  gnomeExtensions = prev.gnomeExtensions // {
    just-perfection = prev.gnomeExtensions.just-perfection.overrideAttrs (oldAttrs: {
      patches = [ ./fix-freeze.patch ];
    });
  };
}
