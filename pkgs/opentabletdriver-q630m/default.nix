{
  lib,
  buildDotnetModule,
  copyDesktopItems,
  coreutils,
  dotnetCorePackages,
  fetchFromGitHub,
  gtk3,
  jq,
  libappindicator,
  libevdev,
  libnotify,
  libx11,
  libxrandr,
  makeDesktopItem,
  udev,
  udevCheckHook,
  wrapGAppsHook3,
}:
buildDotnetModule (finalAttrs: {
  pname = "OpenTabletDriver";
  version = "0.6.7-060571d";

  src = fetchFromGitHub {
    owner = "OpenTabletDriver";
    repo = "OpenTabletDriver";
    rev = "060571d8eb4e2487d7268659113cf224e0fded7a";
    hash = "sha256-087sG7rve/ipcQpn+73YZLVkE11ZWow7qy2dokW8N3w=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  projectFile = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];
  nugetDeps = ./deps.json;

  executables = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    udevCheckHook
    jq
  ];

  runtimeDeps = [
    gtk3
    libappindicator
    libevdev
    libnotify
    libx11
    libxrandr
    udev
  ];

  buildInputs = finalAttrs.runtimeDeps;

  env.OTD_CONFIGURATIONS = "${finalAttrs.src}/OpenTabletDriver.Configurations/Configurations";

  doCheck = false;

  preBuild = ''
    cp ${./Q630M.json} OpenTabletDriver.Configurations/Configurations/Huion/Q630M.json

    patchShebangs generate-rules.sh
    substituteInPlace generate-rules.sh \
      --replace-fail '/usr/bin/env rm' '${lib.getExe' coreutils "rm"}'
  '';

  postFixup = ''
    mv $out/bin/OpenTabletDriver.Console $out/bin/otd
    mv $out/bin/OpenTabletDriver.Daemon $out/bin/otd-daemon
    mv $out/bin/OpenTabletDriver.UX.Gtk $out/bin/otd-gui

    install -Dm644 $src/OpenTabletDriver.UX/Assets/otd.png -t $out/share/icons

    mkdir -p $out/lib/udev/rules.d
    ./generate-rules.sh > $out/lib/udev/rules.d/70-opentabletdriver.rules
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "OpenTabletDriver";
      name = "OpenTabletDriver";
      exec = "otd-gui";
      icon = "otd";
      comment = "Open source, cross-platform, user-mode tablet driver";
      categories = ["Utility"];
    })
  ];

  meta = {
    changelog = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v${finalAttrs.version}";
    description = "Open source, cross-platform, user-mode tablet driver";
    homepage = "https://github.com/OpenTabletDriver/OpenTabletDriver";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "otd";
    maintainers = with lib.maintainers; [
      gepbird
      thiagokokada
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
