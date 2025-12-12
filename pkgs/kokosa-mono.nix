{
  stdenvNoCC,
  fetchzip,
  iosevka,
}:
stdenvNoCC.mkDerivation rec {
  pname = "kokosa-mono";
  version = "0.1.1-test-fix";

  src = fetchzip {
    url = "https://github.com/hatanokokosa/kokosa-mono/releases/download/v${version}/PkgTTF-KokosaMono.zip";
    hash = "sha256-smxo7oh9x7xy5xhmqr/gfjTwZMyuault0vueLgu3sHg=";
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
    inherit (iosevka.meta) license platforms;
  };
}
