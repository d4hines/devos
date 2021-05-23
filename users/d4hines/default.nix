{ lib, ... }:
{
  home-manager.users.d4hines = { suites, ... }: {
    imports = suites.base;
  };

  users.users.d4hines = {
    uid = 1000;
    hashedPassword = lib.fileContents ../../secrets/userPass;
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
