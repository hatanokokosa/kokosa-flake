# nix-ld Configuration
#
# nix-ld enables running unpatched dynamic binaries on NixOS by providing
# a compatibility shim for the standard library loader path.
{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Reuse Steam's FHS environment libraries for nix-ld
      #
      # steam-run creates a complete FHS (Filesystem Hierarchy Standard)
      # environment with most common libraries that games and applications
      # expect. By symlinking its lib64 directory, we get a comprehensive
      # set of dynamic libraries without manually listing hundreds of packages.
      #
      # This is a clever trick to support most non-Nix binaries (AppImages,
      # downloaded executables, etc.) with minimal configuration.
      (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")

      # Additional libraries not included in steam-run
      icu
    ];
  };
}
