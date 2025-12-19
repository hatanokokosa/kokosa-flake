{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "kokosa-mono";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/hatanokokosa/kokosa-mono/releases/download/v${version}/PkgTTF-KokosaMono.zip";
    hash = "sha256-x3q2C8omMBAGPvZ2RJtOL1X1JNeZLTUEMEpT6BNOgE0=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/hatanokokosa/kokosa-mono";
    description = "Custom Iosevka build plan Kokosa Mono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
