self: super: {
  gnomeExtensions = super.gnomeExtensions // {
    just-perfection = super.gnomeExtensions.just-perfection.overrideAttrs (oldAttrs: {
      patches = [ ./fix-freeze.patch ];
    });
  };
}
