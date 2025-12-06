{pkgs, ...}: let
  mononoki-maple-hybrid = pkgs.stdenv.mkDerivation {
    pname = "mononoki-maple-hybrid";
    version = "1.0.0";

    nativeBuildInputs = [pkgs.fontforge];
    dontUnpack = true;

    buildPhase = ''
      mkdir -p $out/share/fonts/truetype

      cat > merge.py <<EOF
      import fontforge
      import os
      import sys

      def find_font(path_prefix, name_keyword):
          for root, dirs, files in os.walk(path_prefix):
              for file in files:
                  if file.startswith("._"): continue
                  if name_keyword in file and (file.endswith(".ttf") or file.endswith(".otf")):
                      if "Italic" not in file:
                          return os.path.join(root, file)

          print(f"Error: Could not find font containing '{name_keyword}' in {path_prefix}")
          print(f"Files found in {path_prefix}:")
          for root, dirs, files in os.walk(path_prefix):
              for f in files:
                  print(os.path.join(root, f))
          sys.exit(1)

      mono_path = find_font("${pkgs.mononoki}", "mononoki-Bold")
      maple_path = find_font("${pkgs.maple-mono.Normal-TTF}", "Medium")

      print(f"Base (Maple Medium): {maple_path}")
      print(f"Overlay (Mononoki Bold): {mono_path}")

      base = fontforge.open(maple_path)
      overlay = fontforge.open(mono_path)

      overlay.em = base.em

      target_width = base[ord(' ')].width

      ranges = [
          (0x30, 0x39),
          (0x41, 0x5A),
          (0x61, 0x7A)
      ]

      print("Patching letters from Mononoki into Maple Medium...")
      for start, end in ranges:
          overlay.selection.select(("ranges",), start, end)
          overlay.copy()
          base.selection.select(("ranges",), start, end)
          base.paste()

          for code in range(start, end + 1):
              if code in base:
                  glyph = base[code]
                  bbox = glyph.boundingBox()
                  ink_width = bbox[2] - bbox[0]
                  new_lsb = (target_width - ink_width) / 2
                  glyph.left_side_bearing = int(new_lsb)
                  glyph.width = target_width

      # Rename Font
      new_family = "Mononoki Maple"
      new_full = "Mononoki Maple Medium"

      base.fontname = "MononokiMaple-Regular"
      base.familyname = new_family
      base.fullname = new_full

      base.appendSFNTName('English (US)', 'Family', new_family)
      base.appendSFNTName('English (US)', 'Fullname', new_full)
      base.appendSFNTName('English (US)', 'Preferred Family', new_family)
      base.appendSFNTName('English (US)', 'Compatible Full', new_full)

      base.appendSFNTName('English (US)', 'SubFamily', 'Regular')

      out_file = os.path.join(os.environ["out"], "share/fonts/truetype/MononokiMaple-Regular.ttf")
      base.generate(out_file)
      EOF

      fontforge -lang=py -script merge.py
    '';
  };
in {
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
    };

    # Fcitx5 Input Method
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          qt6Packages.fcitx5-configtool
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          fcitx5-fluent
        ];
      };
    };
  };

  # Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (inter.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dt $out/share/fonts/truetype/ InterVariable*.ttf
          runHook postInstall
        '';
      })
      (source-serif.overrideAttrs {
        installPhase = ''
          runHook preInstall
          install -Dt $out/share/fonts/variable/ VAR/*.otf
          runHook postInstall
        '';
      })
      nur.repos.rewine.ttf-wps-fonts
      nur.repos.rewine.ttf-ms-win10
      nerd-fonts.symbols-only
      source-han-serif-vf-otf
      source-han-sans-vf-otf
      texlivePackages.fandol
      noto-fonts-color-emoji
      mononoki-maple-hybrid
      maple-mono.CN
      noto-fonts
      mononoki
      iosevka
    ];

    # Font Config
    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Mononoki Maple"
          "FZSJ-ZHUZAYTB"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter Variable"
          "Source Han Sans SC VF"
          "Noto Color Emoji"
        ];
        serif = [
          "Source Serif 4 Variable"
          "Source Han Serif SC VF"
          "Noto Color Emoji"
        ];
      };

      localConf = ''
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>Noto Sans</string>
              </patelt>
            </pattern>
          </rejectfont>
        </selectfont>
      '';
    };
  };
}
