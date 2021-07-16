{ lib, pkgs, config, modulesPath, suites, ... }:

with lib;

let
  defaultUser = "d4hines";
  syschdemd = pkgs.substituteAll {
  	name = "syschdemd";
	  src = ./syschdemd.sh;
	  dir = "bin";
	  isExecutable = true;

	  buildInputs = with pkgs; [ daemonize ];
          inherit (pkgs) daemonize;
	  inherit defaultUser;
	  inherit (config.security) wrapperDir;
	  fsPackagesPath = lib.makeBinPath config.system.fsPackages;
  };
in
{
  imports = suites.base;
  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  networking.dhcpcd.enable = false;

  users.users.root.shell = "${syschdemd}/bin/syschdemd";
  # Otherwise WSL fails to login as root with "initgroups failed 5"
  users.users.root. extraGroups = [ "root" ];

  security.sudo.wheelNeedsPassword = false;

  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;
}