{ config, pkgs, lib, ... }:

{
  options.module-synapse.enable = lib.mkEnableOption "Enables Synapse server (Matrix)";

  config = lib.mkIf config.module-synapse.enable
  { 
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "matrix-synapse" ];
      ensureUsers = [
        {
          name = "matrix-synapse";
          ensureDBOwnership = true;
        }
      ];
    };

    services.matrix-synapse.enable = true;
    services.matrix-synapse = {
      # settings.server_name = "Econadzor";
      settings.public_baseurl = "https://econadzor-test.ru";
      settings.listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];

      settings.registration_shared_secret = "jaXYNoPbHnNQcDiczMYSqrKOy7nloLi2Yxbdse7365w49WpMly3Oz00Gxoyko94X";
    };

    services.nginx = {
      virtualHosts."econadzor-test.ru" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://[::1]:8008";
        };
      };
    };
  };
}
