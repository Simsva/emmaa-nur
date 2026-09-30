{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.shallot;

  missingSlugSites = filter (s: isNull s.slug) cfg.sites;
  missingUrlSites = filter (s: isNull s.url) cfg.sites;

  shallotExe = getExe' cfg.package "shallot";
in
{
  options.services.shallot = {
    enable = mkEnableOption "Enable shallot service";
    package = mkOption {
      description = "The shallot package to use";
      type = types.package;
      default = pkgs.shallot;
    };
    user = mkOption {
      description = "User to run the service as";
      type = types.str;
      default = "shallot";
    };
    group = mkOption {
      description = "Group to run the service as";
      type = types.str;
      default = "shallot";
    };

    port = mkOption {
      description = "Port to listen on";
      type = types.port;
      default = 5000;
    };
    index = mkOption {
      description = "HTML file to serve as the homepage. See the shallot repo on git.emmaa.tech for more information.";
      type = types.path;
      default = "${config.services.shallot.package}/examples/index.html";
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

    systemd.services.shallot =
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
          ExecStart = "${shallotExe}";
          User = cfg.user;
          RuntimeDirectory = "shallot";
          RuntimeDirectoryPreserve = "no";
          WorkingDirectory = "/run/shallot";
        };
      };
  };
}
