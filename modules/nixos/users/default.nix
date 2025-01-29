{ lib, ... }:

let
  # Get all directories in the current directory
  dirs = lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.);

  # Create user entries from directory names
  userNames = lib.mapAttrs' (name: _: lib.nameValuePair name { create = false; }) dirs;
in
{
  snowfallorg.users = userNames;
}
