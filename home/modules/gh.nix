{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hm.gh;
in {
  options.my.hm.gh = {
    enable = lib.mkEnableOption "Enable GitHub CLI via Home Manager";

    gitProtocol = lib.mkOption {
      description = "Protocol to use for git operations";
      type = lib.types.enum ["https" "ssh"];
      default = "ssh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      extensions = with pkgs; [gh-dash gh-copilot];
      enable = true;
      settings = {
        git_protocol = cfg.gitProtocol;
        prompt = "enabled";
        editor = "nvim";
      };
    };
  };
}
