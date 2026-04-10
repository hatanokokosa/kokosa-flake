{config, ...}: let
  homeDir = config.users.users.hatano.home;
in {
  services.syncthing = {
    configDir = "${homeDir}/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    dataDir = homeDir;
    group = "users";
    user = "hatano";
    guiPasswordFile = config.age.secrets.syncthing-gui-password.path;
    enable = true;
    settings = {
      gui = {
        user = "kokosa";
      };
    };
    openDefaultPorts = true;
  };
}
