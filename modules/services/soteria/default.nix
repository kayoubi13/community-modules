{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.soteria;
in
{
  options.services.soteria = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable Soteria, a Polkit authentication agent
        for any desktop environment.

        ::: {.note}
        You should only enable this if you are on a Desktop Environment that
        does not provide a graphical polkit authentication agent, or you are on
        a standalone window manager or Wayland compositor.
        :::
      '';
    };
    package = lib.mkPackageOption pkgs "soteria" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    finit.services.polkit-soteria = {
      description = "Soteria, Polkit authentication agent for any desktop environment";
      runlevels = "2345";
      conditions = "service/syslogd/ready";
      command = lib.getExe cfg.package;
    };
  };
}
