final: prev: {
  mfc5860cnlpr = prev.mfc465cnlpr.overrideAttrs (oldAttrs: rec {
    pname = "mfc5860cnlpr";
    version = "1.0.1-1";
    src = prev.fetchurl {
      url = "https://download.brother.com/welcome/dlf006164/${pname}-${version}.i386.deb";
      sha256 = "sha256-yXDR5tqK7Jh7mCIQ/cMagKFwNSbMtZIa8KPppLIRcO0=";
    };

    installPhase = builtins.replaceStrings ["465"] ["5860"] oldAttrs.installPhase;
  });

  mfc5860cncupswrapper = prev.mfc465cncupswrapper.overrideAttrs (oldAttrs: rec {
    pname = "mfc5860cncupswrapper";
    version = "1.0.1-1";
    src = prev.fetchurl {
      url = "https://download.brother.com/welcome/dlf006166/${pname}-${version}.i386.deb";
      sha256 = "sha256-wQm2EHLFtqeUKNKTYD589fHZ6lgafVpuBLFe+NwdHIA=";
    };

    installPhase = builtins.replaceStrings ["465" prev.mfc465cnlpr.outPath] ["5860" final.mfc5860cnlpr.outPath] oldAttrs.installPhase;
  });
}
