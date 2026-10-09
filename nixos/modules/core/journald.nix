{options, ...}: {
  services.journald =
    if options.services.journald ? settings
    then {
      settings.Journal.SystemMaxUse = "300M";
    }
    else {
      extraConfig = "SystemMaxUse=300M";
    };
}
