final: prev: {
  python3Packages = with prev.python3Packages; prev.python3Packages // {
    multitimer = buildPythonPackage rec {
      pname = "multitimer";
      version = "0.3";

      src = fetchPypi {
        inherit pname version;
        extension = "zip";
        hash = "sha256-4GZZFQU45ixcy1MbZ6eY47A0rSu1ygJOve9S+mZ1knQ=";
      };

	  pyproject = true;
      build-system = [
        setuptools
      ];

      meta = {
        changelog = "https://github.com/joshburnett/multitimer/releases/tag/${version}";
        homepage = "https://github.com/joshburnett/multitimer";
        description = "A pure-python periodic timer that can be started multiple times";
        license = lib.licenses.mit;
      };
    };
    rpi-lgpio = buildPythonPackage rec {
      pname = "rpi-lgpio";
      version = "0.6";

      src = fetchPypi {
        inherit version;
        pname = "rpi_lgpio";
        hash = "sha256-hFebEdVDu4q93cHhD81r3CgZ5Yl75y1pSaKwRNcftz4=";
      };

	  pyproject = true;
      build-system = [
        setuptools
      ];

      dependencies = [
        ((import ./lgpio.nix) prev).python3Packages.lgpio
      ];

      meta = {
        changelog = "https://github.com/waveform80/rpi-lgpio/releases/tag/${version}";
        homepage = "https://github.com/waveform80/rpi-lgpio";
        description = "A compatibility shim for lgpio emulating the RPi.GPIO API";
        license = lib.licenses.mit;
      };
    };
  };
}
