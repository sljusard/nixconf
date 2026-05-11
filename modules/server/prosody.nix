{ config, pkgs, lib, ... }:

{
  options.module-prosody.enable = lib.mkEnableOption "Enables Prosody server (XMPP)";

  config = lib.mkIf config.module-prosody.enable
  {
    services.prosody = {
      enable = true;
      admins = [ "sljusard@econadzor.org"];
      ssl.cert = "/var/lib/acme/econadzor.org/fullchain.pem";
      ssl.key = "/var/lib/acme/econadzor.org/key.pem";
      extraConfig = ''
        external_addresses = { "151.252.80.120" }
        c2s_ports = { 5222 }
        s2s_ports = { 5269 }
        turn_external_host = "turn.xmpp.econadzor.org"
      '';
      virtualHosts."econadzor.org" = {
        enabled = true;
        domain = "econadzor.org";
        ssl.cert = "/var/lib/acme/econadzor.org/fullchain.pem";
        ssl.key = "/var/lib/acme/econadzor.org/key.pem";
      };
      muc = [ { domain = "conference.econadzor.org"; } ];
      httpFileShare = {
        domain = "upload.econadzor.org";
      };
      disco_items = [
        {
           description = "http upload";
           url = "upload.xmpp.econadzor.org";
        }
      ];
      allowRegistration = false;
      authentication = "internal_plain";
      s2sSecureAuth = true;
      c2sRequireEncryption = true;
      modules = {
        admin_adhoc = true;
        cloud_notify = true;
        pep = true;
        blocklist = true;
        bookmarks = true;
        dialback = true;
        ping = true;
        private = true;
        register = false;
        vcard_legacy = false;
      };
      xmppComplianceSuite = true;
    };

    users.groups.acme.members = [ "prosody" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "sljusarde@gmail.com";
      defaults.webroot = "/var/lib/acme/acme-challenge";
      certs."econadzor.org" = {
          group = "acme";
          email = "sljusarde@gmail.com";
          extraDomainNames = [
            "conference.econadzor.org"
            "upload.econadzor.org"
          ];
      };
    };

    services.caddy.virtualHosts."econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:5281
    '';

    networking.firewall.allowedTCPPorts = [ 5222 5223 5269 5280 5281 ];
  };
}
