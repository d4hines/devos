{ lib, ... }:
{
  home-manager.users.d4hines = { suites, ... }: {
    imports = suites.base;
    programs.git.userName = "Daniel Hines";
    programs.git.userEmail = "d4hines@gmail.com";
  };

  users.users.d4hines = {
    uid = 1000;
    hashedPassword = lib.fileContents ../../secrets/userPass;
    description = "Daniel Hines";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
