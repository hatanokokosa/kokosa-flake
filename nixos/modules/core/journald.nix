{...}: {
  services.journald.settings.Journal = {
    SystemMaxUse = "300M";
  };
}
