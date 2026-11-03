{ config, pkgs, lib, ... }: {

  flake.nixosModules.livekit = { config, pkgs, lib, ... }:
  let
    keyFile = "/etc/livekit/keys.yaml";
  in {
    services.livekit = {
      enable = true;
      inherit keyFile;
      settings = {
        port = 7880;
        rtc = {
          tcp_port = 7881;
          port_range_start = 50100;
          port_range_end = 50200;
          use_external_ip = true;
        };
        turn = {
          enabled = true;
          udp_port = 3478;
          relay_range_start = 50300;
          relay_range_end = 50400;
          domain = "livekit.econadzor.org";
        };
        room.auto_create = false;
      };
    };

    services.lk-jwt-service = {
      enable = true;
      port = 8081; # Caddy already points here
      livekitUrl = "wss://livekit.econadzor.org";
      inherit keyFile;
    };
    systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "econadzor.org";

    services.caddy.virtualHosts."livekit.econadzor.org".extraConfig = ''
      @lk-jwt-service path /sfu/get* /healthz* /get_token*
      route @lk-jwt-service {
        reverse_proxy 127.0.0.1:8081
      }
      reverse_proxy 127.0.0.1:7880
    '';

    networking.firewall.allowedTCPPorts = [ 7881 ];
    networking.firewall.allowedUDPPortRanges = [
      { from = 50100; to = 50200; } # WebRTC media
      { from = 50300; to = 50400; } # TURN relay
    ];
    networking.firewall.allowedUDPPorts = [ 3478 ]; # TURN
  };
}
