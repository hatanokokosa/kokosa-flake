{inputs, ...}: {
  imports = [inputs.selector4nix.nixosModules.selector4nix];

  services.selector4nix = {
    enable = true;
    configureSubstituter = "prepend";
    enablePersistentCaching = true;
    settings.substituters = [
      {url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/";}
      {url = "https://mirrors.ustc.edu.cn/nix-channels/store/";}
      {url = "https://mirror.sjtu.edu.cn/nix-channels/store/";}
      {url = "https://cache.nixos.org/";}
      {url = "https://cache.numtide.com/";}
      {url = "https://nix-community.cachix.org/";}
      {url = "https://attic.xuyh0120.win/lantian/";}
    ];
  };
}
