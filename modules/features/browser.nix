{pkgs, ...}: {
  programs = {
    firefox = {
      enable = true;
      languagePacks = ["fr"];

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "emoji@saveriomorelli.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/emoji-sav/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = {
          "browser.contentblocking.category" = {
            Value = "strict";
            Status = "locked";
          };
          "browser.topsites.contile.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.showSearchSuggestionsFirst" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.feeds.section.topstories" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.feeds.snippets" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.showSponsored" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.system.showSponsored" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = {
            Value = false;
            Status = "locked";
          };
          "browser.tabs.drawInTitlebar" = {
            Value = true;
            Status = "locked";
          };
          "sidebar.revamp" = {
            Value = true;
            Status = "locked";
          };
          "sidebar.verticalTabs" = {
            Value = true;
            Status = "locked";
          };
          "signon.rememberSignons" = {
            Value = false;
            Status = "locked";
          };
          "signon.autofillForms" = {
            Value = false;
            Status = "locked";
          };
          "signon.autologin.proxy" = {
            Value = false;
            Status = "locked";
          };
          "signon.privateBrowsingCapture.enabled" = {
            Value = false;
            Status = "locked";
          };
          "signon.showAutoCompleteFooter" = {
            Value = false;
            Status = "locked";
          };
          "signon.showAutoCompleteOrigins" = {
            Value = false;
            Status = "locked";
          };
          "signon.management.page.breach-alerts.enabled" = {
            Value = false;
            Status = "locked";
          };
        };
      };
    };

    chromium = {
      enable = true;

      extensions = [
        "uBlock0@raymondhill.net"
        "bitwarden-password-manager"
      ];
    };
  };
}
