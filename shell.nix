with import <nixpkgs> {};

mkShell {
  nativeBuildInputs = with buildPackages; [
    packer
    terraform
    nomad
  ];
}