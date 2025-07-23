final: prev: {
  gruvbox-factory = prev.python3Packages.buildPythonApplication rec {
    pname = "gruvbox-factory";
    version = "1.1.0";

    src = prev.fetchPypi {
      inherit version;
      pname = "gruvbox_factory";
      hash  = "sha256-ak8YVqwPTj+9MbS9BWbOQDgvAP/S/EvcVxH40Qt9AZ0=";
    };

    dependencies = with prev.python3Packages; [
      rich
      image-go-nord
    ];

    pyproject = true;
    build-system = [ prev.python3Packages.setuptools ];
  };
}
