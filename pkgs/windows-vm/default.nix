{
  lib,
  writeShellApplication,
  makeDesktopItem,
  symlinkJoin,
  qemu,
  libvirt,
  virtiofsd,
  python3,
  coreutils,
  util-linux,
}: let
  launcher = writeShellApplication {
    name = "windows-vm";
    runtimeInputs = [libvirt python3 coreutils util-linux];
    text = ''
      data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/windows-vm"
      runtime_dir="''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR must be set}/windows-vm"
      shared_dir="$HOME/Public/Windows"
      disk="$data_dir/windows11.qcow2"
      vars="$data_dir/OVMF_VARS.fd"
      uri=qemu:///session

      if [[ ! -f "$disk" ]]; then
        printf 'Windows system disk not found: %s\n' "$disk" >&2
        exit 1
      fi

      install -d -m 700 "$runtime_dir" "$shared_dir"
      exec 9>"$runtime_dir/lock"
      flock 9

      if [[ ! -f "$vars" ]]; then
        cp ${qemu}/share/qemu/edk2-i386-vars.fd "$vars"
        chmod u+w "$vars"
      fi

      state="$(LC_ALL=C virsh --connect "$uri" domstate windows11 2>/dev/null || true)"
      if [[ -z "$state" || "$state" == 'shut off' ]]; then
        python3 - "$disk" "$vars" "$shared_dir" > "$runtime_dir/domain.xml" <<'PY'
      import sys
      import os
      import xml.etree.ElementTree as ET

      ET.register_namespace("qemu", "http://libvirt.org/schemas/domain/qemu/1.0")
      tree = ET.parse("${./windows-vm.xml}")
      root = tree.getroot()
      root.find("os/loader").text = "${qemu}/share/qemu/edk2-x86_64-code.fd"
      root.find("os/nvram").text = sys.argv[2]
      root.find("devices/emulator").text = "${qemu}/bin/qemu-system-x86_64"
      root.find("devices/disk/source").set("file", sys.argv[1])
      root.find("devices/filesystem/source").set("dir", sys.argv[3])
      root.find("devices/filesystem/binary").set("path", "${virtiofsd}/bin/virtiofsd")
      root.find("devices/audio").set("runtimeDir", os.environ["XDG_RUNTIME_DIR"])
      graphics = root.find("devices/graphics")
      display_env = {
          "XDG_RUNTIME_DIR": os.environ["XDG_RUNTIME_DIR"],
          "SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY": "1",
      }
      if os.environ.get("WAYLAND_DISPLAY"):
          display_env["WAYLAND_DISPLAY"] = os.environ["WAYLAND_DISPLAY"]
          display_env["SDL_VIDEODRIVER"] = "wayland"
      elif os.environ.get("DISPLAY"):
          graphics.set("display", os.environ["DISPLAY"])
          if os.environ.get("XAUTHORITY"):
              graphics.set("xauth", os.environ["XAUTHORITY"])
          display_env["SDL_VIDEODRIVER"] = "x11"
      else:
          raise SystemExit("Windows VM requires a local graphical session.")
      commandline = ET.SubElement(root, "{http://libvirt.org/schemas/domain/qemu/1.0}commandline")
      for name, value in display_env.items():
          ET.SubElement(commandline, "{http://libvirt.org/schemas/domain/qemu/1.0}env",
                        {"name": name, "value": value})
      tree.write(sys.stdout, encoding="unicode")
      PY
        virsh --connect "$uri" define "$runtime_dir/domain.xml"
        virsh --connect "$uri" start windows11
      fi
      flock -u 9
      exec 9>&-
    '';
  };
  desktop = makeDesktopItem {
    name = "windows-vm";
    desktopName = "Windows 11";
    comment = "SDL Windows VM with shared GPU, folder and PipeWire sound";
    exec = "${launcher}/bin/windows-vm";
    icon = "computer";
    categories = ["System" "Emulator"];
    terminal = false;
  };
in
  symlinkJoin {
    name = "windows-vm";
    paths = [launcher desktop];
    meta = {
      description = "Windows 11 on libvirt with SDL Venus graphics, VirtIO-FS and PipeWire audio";
      mainProgram = "windows-vm";
      platforms = ["x86_64-linux"];
      license = lib.licenses.mit;
    };
  }
