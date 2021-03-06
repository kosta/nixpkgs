{ lib, callPackage, fetchurl, fetchpatch }:

let
  generic = args: callPackage (import ./generic.nix args) { };
in
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "387.22";
    sha256_32bit = "16v4ljq07hs1xw6amc7cmddvmmmd3swli3b617xs8f3qcw54ym1r";
    sha256_64bit = "1i0fmzsv4bkfxaw2wnnhj2z64gdyqd6xvxrsq7zj7gq7crcd6sma";
    settingsSha256 = "0wszyfj9hcib7dcfin22nsrfsm1mb4rq6ha5fma7sq68p175j1yk";
    persistencedSha256 = "0wrkmw8gw780vcl0s0d0vd8niaf741ji5sggxxqb1aa1w61rjf0d";
  };

  beta = generic {
    version = "381.22";
    sha256_32bit = "024x3c6hrivg2bkbzv1xd0585hvpa2kbn1y2gwvca7c73kpdczbv";
    sha256_64bit = "13fj9ndy5rmh410d0vi2b0crfl7rbsm6rn7cwms0frdzkyhshghs";
    settingsSha256 = "1gls187zfd201b29qfvwvqvl5gvp5wl9lq966vd28crwqh174jrh";
    persistencedSha256 = "08315rb9l932fgvy758an5vh3jgks0qc4g36xip4l32pkxd9k963";
  };

  legacy_340 = generic {
    version = "340.104";
    sha256_32bit = "1l8w95qpxmkw33c4lsf5ar9w2fkhky4x23rlpqvp1j66wbw1b473";
    sha256_64bit = "18k65gx6jg956zxyfz31xdp914sq3msn665a759bdbryksbk3wds";
    settingsSha256 = "1vvpqimvld2iyfjgb9wvs7ca0b0f68jzfdpr0icbyxk4vhsq7sxk";
    persistencedSha256 = "0zqws2vsrxbxhv6z0nn2galnghcsilcn3s0f70bpm6jqj9wzy7x8";
    useGLVND = false;

    patches = [
    ];
  };

  legacy_304 = generic {
    version = "304.135";
    sha256_32bit = "14qdl39wird04sqba94dcb77i63igmxxav62ndr4qyyavn8s3c2w";
    sha256_64bit = "125mianhvq591np7y5jjrv9vmpbvixnkicr49ni48mcr0yjnjqkh";
    settingsSha256 = "1y7swikdngq4nlwzkrq20yfah9zr31n1a5i6nw37awnp8xjilhzm";
    persistencedSha256 = null;
    useGLVND = false;
    useProfiles = false;

    prePatch = let
      debPatches = fetchurl {
        url = "mirror://debian/pool/non-free/n/nvidia-graphics-drivers-legacy-304xx/"
            + "nvidia-graphics-drivers-legacy-304xx_304.135-2.debian.tar.xz";
        sha256 = "0mhji0ssn7075q5a650idigs48kzf11pzj2ca2n07rwxg3vj6pdr";
      };
      prefix = "debian/module/debian/patches";
      applyPatches = pnames: if pnames == [] then null else
        ''
          tar xf '${debPatches}'
          sed 's|^\([+-]\{3\} [ab]\)/|\1/kernel/|' -i ${prefix}/*.patch
          patches="$patches ${lib.concatMapStringsSep " " (pname: "${prefix}/${pname}.patch") pnames}"
        '';
    in applyPatches [ "fix-typos" "drm-driver-legacy" "deprecated-cpu-events" "disable-mtrr" ];
  };

  legacy_173 = callPackage ./legacy173.nix { };
}
