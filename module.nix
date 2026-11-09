{ config, lib, pkgs, ... }:
let
  cfg = config.programs.sddm-themes;

  themesDir = ./themes;
  available = lib.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir themesDir)
  );

  themePkg = pkgs.runCommandLocal "sddm-theme-${cfg.theme}" { } ''
    mkdir -p $out/share/sddm/themes
    cp -r ${themesDir + "/${cfg.theme}"} $out/share/sddm/themes/${cfg.theme}
  '';

  hasCursor = cfg.cursorName != null;
in
{
  options.programs.sddm-themes = {
    enable = lib.mkEnableOption "SDDM với theme cá nhân";

    theme = lib.mkOption {
      type = lib.types.enum available;
      description = "Tên thư mục trong themes/ muốn dùng.";
      example = "material-you";
    };

    cursorName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Tên cursor theme cho màn hình đăng nhập.";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Kích thước cursor.";
    };

    cursorPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Package chứa cursor theme, sẽ được thêm vào systemPackages.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ themePkg ] ++ lib.optional (cfg.cursorPackage != null) cfg.cursorPackage;

    services.xserver.enable = lib.mkDefault true;

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      theme = cfg.theme;

      settings.Theme = lib.mkIf hasCursor {
        CursorTheme = cfg.cursorName;
        CursorSize = cfg.cursorSize;
      };

      setupScript = lib.mkIf hasCursor ''
        ${pkgs.xrdb}/bin/xrdb -merge <<EOF
        Xcursor.theme: ${cfg.cursorName}
        Xcursor.size: ${toString cfg.cursorSize}
        EOF
      '';
    };
  };
}