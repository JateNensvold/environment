{ pkgs, aws-sam-translator, fetchFromGitHub }:
let
  new-aws-sam-translator = aws-sam-translator.overrideAttrs (old: rec {
    version = "1.89.0";
    src = fetchFromGitHub {
      owner = "aws";
      repo = "serverless-application-model";
      rev = "refs/tags/v${version}";
      hash = "sha256-elirU6u6smuYIj8oO6s2ybQB8Tu0pJPkBdjd0W0CfFE=";
    };
  });
in new-aws-sam-translator
