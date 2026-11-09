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

  hasCursor = cfg.cursor.name != null;
in
{
  options.programs.sddm-themes = {
    enable = lib.mkEnableOption "SDDM với theme cá nhân";

    theme = lib.mkOption {
      type = lib.types.enum available;
      description = "Tên thư mục trong themes/ muốn dùng.";
      example = "material-you";
    };

    cursor = lib.mkOption {
      default = { };
      description = "Cursor cho màn hình đăng nhập.";
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Tên cursor theme.";
          };
          size = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "Kích thước cursor.";
          };
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Package chứa cursor theme, sẽ được thêm vào systemPackages.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      [ themePkg ] ++ lib.optional (cfg.cursor.package != null) cfg.cursor.package;

    services.xserver.enable = lib.mkDefault true;

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      theme = cfg.theme;

      settings.Theme = lib.mkIf hasCursor {
        CursorTheme = cfg.cursor.name;
        CursorSize = cfg.cursor.size;
      };

      setupScript = lib.mkIf hasCursor ''
        ${pkgs.xrdb}/bin/xrdb -merge <<EOF
        Xcursor.theme: ${cfg.cursor.name}
        Xcursor.size: ${toString cfg.cursor.size}
        EOF
      '';
    };
  };
}
