{inputs, ...}: {
  # 统一的 overlays 定义
  flake.overlays = {
    default = final: prev: {
      kokosa-mono = prev.callPackage "${inputs.self}/pkgs/kokosa-mono.nix" {};
    };

    # 包含所有 overlays 的组合
    all = final: prev: let
      overlays = [
        inputs.self.overlays.default
        inputs.nur.overlays.default
        (f: p: {
          hid-bpf-uclogic = inputs.hid-bpf-uclogic.packages.${prev.stdenv.hostPlatform.system}.default;
        })
      ];
    in
      builtins.foldl' (acc: overlay: acc // (overlay final (prev // acc))) {} overlays;
  };
}
