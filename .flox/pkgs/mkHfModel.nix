# mkHfModel.nix — shared builder for HuggingFace model packages (vLLM)
#
# Copies a local model snapshot into the HF cache layout expected by
# vllm-resolve-model's `flox` source:
#   $out/share/models/hub/models--<slug>/snapshots/<snapshotId>/
#
# Uses sandbox = "off" so local paths are accessible.
#
# Usage (from per-model .nix files):
#   { pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:
#   mkHfModel { pname = "..."; version = "..."; srcPath = /path/to/snapshot; ... }
{ stdenv }:
{ pname, version, srcPath, slug, snapshotId }:

stdenv.mkDerivation {
  inherit pname version;
  src = srcPath;
  dontBuild = true;
  installPhase = ''
    _snap="$out/share/models/hub/models--${slug}/snapshots/${snapshotId}"
    mkdir -p "$_snap"
    cp -rL $src/* "$_snap/"
    mkdir -p "$out/share/models/hub/models--${slug}/refs"
    echo -n "${snapshotId}" > "$out/share/models/hub/models--${slug}/refs/main"
  '';
}
