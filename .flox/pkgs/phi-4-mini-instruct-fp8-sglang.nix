# Phi-4-mini-instruct FP8-TORCHAO (SGLang-compatible)
#
# Same weights as phi-4-mini-instruct-fp8-hf but with tokenizer_config.json
# patched: tokenizer_class "TokenizersBackend" -> "PreTrainedTokenizerFast".
# SGLang 0.5.9 ships transformers 4.57.6 which doesn't recognize
# TokenizersBackend (added in transformers 4.58).
#
# Remove this package once SGLang ships transformers >=4.58.
{ pkgs }:

let
  buildMeta = builtins.fromJSON (builtins.readFile ../../build-meta/phi-4-mini-instruct-fp8-sglang.json);
  baseVersion = "1.0.0";
  version = "${baseVersion}+${buildMeta.git_rev_short}";
  slug = "microsoft--Phi-4-mini-instruct-FP8-TORCHAO";
  snapshotId = "b63ecd840bb9835f35e6d884d47810c4deec89dc";
  pname = "phi-4-mini-instruct-fp8-sglang";
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  src = /mnt/scratch/models/inferencing/hub/models--microsoft--Phi-4-mini-instruct-FP8-TORCHAO/snapshots/b63ecd840bb9835f35e6d884d47810c4deec89dc;
  nativeBuildInputs = [ pkgs.jq ];
  dontBuild = true;
  installPhase = ''
    _snap="$out/share/models/hub/models--${slug}/snapshots/${snapshotId}"
    mkdir -p "$_snap"
    cp -rL $src/* "$_snap/"
    mkdir -p "$out/share/models/hub/models--${slug}/refs"
    echo -n "${snapshotId}" > "$out/share/models/hub/models--${slug}/refs/main"

    # Patch tokenizer_class for SGLang compatibility
    _tc="$_snap/tokenizer_config.json"
    if [ -f "$_tc" ] && grep -q '"TokenizersBackend"' "$_tc"; then
      jq '.tokenizer_class = "PreTrainedTokenizerFast"' "$_tc" > "$_tc.tmp"
      mv "$_tc.tmp" "$_tc"
    fi

    mkdir -p "$out/share/${pname}"
    echo -n "${version}" > "$out/share/${pname}/flox-build-version-${toString buildMeta.build_version}"
  '';
}
