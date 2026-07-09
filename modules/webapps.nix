{ lib, pkgs, ... }:

let
  mkWebApp =
    {
      name,
      url,
      comment ? null,
      icon ? null,
      categories ? [ "Network" ],
    }:
    pkgs.makeDesktopItem {
      inherit name categories;
      desktopName = name;
      exec = "${pkgs.ungoogled-chromium}/bin/chromium --app=\"${url}\"";
      comment = if comment != null then comment else "Web App: ${name}";
      icon = if icon != null then icon else "web-browser";
    };
in
{
  home.packages = [
    (mkWebApp {
      name = "Google Calendar";
      url = "https://calendar.google.com";
    })
    (mkWebApp {
      name = "Google Maps";
      url = "https://maps.google.com";
    })
    (mkWebApp {
      name = "Immich";
      url = "https://immich.404simon.de/photos";
    })
  ];
}
