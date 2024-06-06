{ buildPythonPackage, fetchFromGitHub, pyyaml, regex, sympy, sarif-om
, jschema-to-python, junit-xml, networkx, jsonschema, jsonpatch, callPackage
, ... }:
let aws-sam-translator-1-89 = callPackage ./aws-sam-translator-1-89.nix { };
in buildPythonPackage rec {
  pname = "cfn-lint";
  version = "0.87.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-lint";
    rev = "refs/tags/${version}";
    sha256 = "sha256-fs5V7dUo7IjfbBaYD9RjFUulKqo2kO3HyHQKym8Lo1w=";
  };

  nativeBuildInputs = [ ];

  propagatedBuildInputs = [
    pyyaml
    regex
    sympy
    sarif-om
    jschema-to-python
    junit-xml
    networkx
    jsonschema
    jsonpatch
    aws-sam-translator-1-89
  ];

  doCheck = false;

  meta = {
    description = "Python application for linting cloudformation files";
    homepage = "https://github.com/aws-cloudformation/cfn-lint";
    changelog =
      "https://github.com/aws-cloudformation/cfn-lint/releases/tag/${version}";
  };
}
