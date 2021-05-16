{ suites, ... }:
{
  imports = [
    ../up/RADAH/configuration.nix
  ] ++ suites.core;
}
