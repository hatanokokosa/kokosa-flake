{
  qemu,
  writeShellApplication,
  symlinkJoin,
}: let
  patched = (qemu.override {hostCpuOnly = true;}).overrideAttrs (old: {
    patches = (old.patches or []) ++ [./qemu-venus-seccomp.patch];
  });
  emulator = writeShellApplication {
    name = "qemu-system-x86_64";
    text = ''
      args=("$@")
      # libvirt appends its sandbox flags last; Venus needs a separate render-server process.
      for ((i = 0; i + 1 < ''${#args[@]}; i++)); do
        if [[ "''${args[i]}" == -sandbox ]]; then
          args[i + 1]="''${args[i + 1]//spawn=deny/spawn=allow}"
        fi
        if [[ "''${args[i]}" == -accel && "''${args[i + 1]}" == kvm ]]; then
          args[i + 1]=kvm,honor-guest-pat=on
        fi
        if [[ "''${args[i]}" == -display && "''${args[i + 1]}" == sdl,* ]]; then
          # Closing a display must not abruptly terminate the managed guest.
          args[i + 1]+=",window-close=off"
        fi
      done
      exec ${patched}/bin/qemu-system-x86_64 "''${args[@]}"
    '';
  };
in
  symlinkJoin {
    name = "qemu-windows-${qemu.version}";
    paths = [emulator patched];
    inherit (qemu) meta version;
  }
