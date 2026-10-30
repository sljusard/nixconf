{ self, inputs, ... }: {

  flake.nixosModules.zapret = { pkgs, lib, ... }: {
    services.zapret2 = {
      enable = true;

      profiles = {
        http.parameters = [
          "--filter-tcp=80"
          "--payload=http_req"
          "--lua-desync=tcpseg:pos=0,midsld:ip_id=rnd:repeats=260"
        ];
        https = {
          parameters = [
            "--filter-tcp=443"
            "--lua-init=fake_default_tls=tls_mod(fake_default_tls,'rnd')"
            "--lua-desync=wssize:wsize=1:scale=6" 
            "--payload=tls_client_hello"
            "--lua-desync=multidisorder:pos=2,midsld:seqovl=1:seqovl_pattern=fake_default_tls"
          ];
          hosts.include = [ "youtube.com" "googlevideo.com" "speedtest.net" ];
          hosts.exclude = [ "ru" ];
          hosts.autodetect.enable = true;
        };
      };

      firewall = {
        interfaces = [ "wlo" ];   # your real WAN interface
        tcpPorts = [ 80 443 ];
        udpPorts = [ 443 ];
      };
    };
  }; 

}
