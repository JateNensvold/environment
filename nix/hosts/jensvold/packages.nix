{ pkgs }:

let
  nixTools = with pkgs; [
    aws-sam-cli
  ];
in
nixTools
