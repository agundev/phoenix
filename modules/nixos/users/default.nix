{ lib, ... }:

let
  # Get all files in the current directory
  files = lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
    (builtins.readDir ./.);
    
  # Remove .nix suffix from filenames and set create = false
  userNames = lib.mapAttrs'
    (name: _: lib.nameValuePair
      (lib.removeSuffix ".nix" name)
      { create = false; })
    files;
in
{
  snowfallorg.users = userNames;
}