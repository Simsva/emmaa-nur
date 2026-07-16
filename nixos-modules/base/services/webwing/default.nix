{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.webwing;

  missingSlugSites = filter (s: isNull s.slug) cfg.sites;
  missingUrlSites = filter (s: isNull s.url) cfg.sites;

  webwingExe = getExe' cfg.package "webwing";
in
{
  options.services.webwing = {
    enable = mkEnableOption "Enable webwing service";
    package = mkOption {
      description = "The webwing package to use";
      type = types.package;
      default = pkgs.webwing;
    };
    user = mkOption {
      description = "User to run the service as";
      type = types.str;
      default = "webwing";
    };
    group = mkOption {
      description = "Group to run the service as";
      type = types.str;
      default = "webwing";
    };

    port = mkOption {
      description = "Port to listen on";
      type = types.port;
      default = 5000;
    };
    index = mkOption {
      description = "HTML file to serve as the homepage. See the webwing repo on GitLab for more information.";
      type = types.path;
      default = "${config.services.webwing.package}/examples/index.html";
    };
    static = mkOption {
      description = "Directory of static files to serve on /static.";
      type = types.nullOr types.path;
      default = null;
    };
    sites = mkOption {
      description = "Sites to include in the webring";
      type = types.listOf (
        types.submodule {
          options = {
            slug = mkOption {
              description = "Slug of the site";
              type = types.str;
            };
            url = mkOption {
              description = "URL of the site";
              type = types.str;
            };
            buttonAltText = mkOption {
              description = "Alt text to use if an 88x31 button GIF is found in the static files";
              type = types.str;
              default = "";
            };
          };
        }
      );
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = length missingSlugSites == 0 && length missingUrlSites == 0;
        message = "Some sites are missing slugs or URLs!";
      }
    ];

    users.users.${cfg.user} = {
      inherit (cfg) group;
      description = "Webwing daemon user";
      isSystemUser = true;
    };
    users.groups.${cfg.group} = { };

    systemd.services.webwing =
      let
        sanitizeText = replaceString "|" "";
        mkSite = site: "${site.slug}|${sanitizeText site.buttonAltText}|${site.url}";
        sitesFile = pkgs.writeText "sites.txt" (concatLines (map mkSite cfg.sites));
      in
      {
        description = "Simple webring server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          ln -s "${sitesFile}" ./sites.txt
          ln -s "${cfg.index}" ./index.html
        ''
        + optionalString (!isNull cfg.static) ''
          ln -s "${cfg.static}" ./static
        '';

        environment = {
          PORT = toString cfg.port;
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = "${webwingExe}";
          User = cfg.user;
          RuntimeDirectory = "webwing";
          RuntimeDirectoryPreserve = "no";
          WorkingDirectory = "/run/webwing";
        };
      };
  };
}
