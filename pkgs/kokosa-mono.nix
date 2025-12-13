{
  stdenvNoCC,
  fetchzip,
  iosevka,
}:
stdenvNoCC.mkDerivation rec {
  pname = "kokosa-mono";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/hatanokokosa/kokosa-mono/releases/download/v${version}/PkgTTF-KokosaMono.zip";
    hash = "sha256-e5tCF66kMGZf8NpKLw3wkldY7MAQzHMP5rjvCO60w6g=";
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
