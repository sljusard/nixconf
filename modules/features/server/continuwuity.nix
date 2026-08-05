{ config, pkgs, lib, ... }: {

  flake.nixosModules.continuwuity = { pkgs, lib, ... }: {
    services.matrix-continuwuity.enable = true;
    services.matrix-continuwuity.settings = {
      global = {
	      server_name = "econadzor.org";
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
	      trusted_servers = [ "matrix.org" ];
	      new_user_displayname_suffix = "";
	      matrix_rtc = {
          foci = [
            { 
              type = "livekit"; 
              livekit_service_url = "https://livekit.econadzor.org"; 
            } 
          ];
	      };
        max_request_size = 200000000;
        well_known = {
          client = "https://matrix.econadzor.org";
          server = "matrix.econadzor.org:443";
          support_email = "sljusarde@gmail.com";
        };
      };
    };

    services.caddy.virtualHosts."matrix.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:6167
    '';

    services.caddy.virtualHosts."matrix.econadzor.org:443".extraConfig = ''
      reverse_proxy 127.0.0.1:6167
    '';

    services.caddy.virtualHosts."econadzor.org:443".extraConfig = ''
      reverse_proxy /.well-known/matrix* 127.0.0.1:6167
    '';

    services.caddy.virtualHosts."livekit.econadzor.org".extraConfig = ''
      @lk-jwt-service path /sfu/get* /healthz* /get_token*
      route @lk-jwt-service {
        reverse_proxy 127.0.0.1:8081
      }

      reverse_proxy 127.0.0.1:7880
     '';

    networking.firewall.allowedTCPPorts = [ 7881 ];
    networking.firewall.allowedUDPPortRanges = [ 
      { from = 50100; to = 50200; } 
      { from = 50300; to = 50400; }
    ];
    networking.firewall.allowedUDPPorts = [ 3478 ];
  };
}
