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
      description = "HTML file to serve as the homepage. See the https://git.emmaa.tech/emma/shallot for more information.";
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
              description = "Alt text to use for the 88x31 button. If left empty a button will not render.";
              type = types.str;
              default = "";
            };
            buttonUrl = mkOption {
              description = "URL to the site's 88x31 button. If left empty it defaults to `/static/buttons/slug.gif`";
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
      description = "Shallot daemon user";
      isSystemUser = true;
    };
    users.groups.${cfg.group} = { };

    systemd.services.shallot =
      let
        sanitizeText = replaceString "|" "";
        sanitizeUrl = replaceString "|" "%7C";
        mkSite =
          site:
          "${sanitizeText site.slug}|${sanitizeUrl site.url}|${sanitizeText site.buttonAltText}|${sanitizeUrl site.buttonUrl}";
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
