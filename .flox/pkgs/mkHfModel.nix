# mkHfModel.nix — shared builder for HuggingFace model packages (vLLM/Triton)
#
# Outputs a Triton-compatible model directory:
#   $out/share/models/<tritonModelName>/
#     config.pbtxt          — standard vLLM Triton backend config
#     model-defaults.json   — vLLM engine defaults (no "model" key; resolved at runtime)
#     weights/              — cp -rL of srcPath contents
#
# Uses sandbox = "off" so local paths are accessible.
#
# Usage (from per-model .nix files):
#   { pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:
#   mkHfModel { pname = "..."; baseVersion = "..."; buildMeta = ...; srcPath = /path/to/snapshot;
#               tritonModelName = "..."; vllmDefaults = { ... }; }
{ stdenv }:
{ pname, baseVersion, buildMeta, srcPath, tritonModelName, vllmDefaults ? {} }:

let
  version = "${baseVersion}+${buildMeta.git_rev_short}";
  defaultsJson = builtins.toJSON vllmDefaults;
in
stdenv.mkDerivation {
  inherit pname version;
  src = srcPath;
  dontBuild = true;
  installPhase = ''
    _model="$out/share/models/${tritonModelName}"
    mkdir -p "$_model/weights"
    cp -rL $src/* "$_model/weights/"

    cat > "$_model/config.pbtxt" << 'PBTXT'
    backend: "vllm"

    instance_group [
      {
        count: 1
        kind: KIND_MODEL
      }
    ]

    model_transaction_policy {
      decoupled: True
    }

    input [
      {
        name: "text_input"
        data_type: TYPE_STRING
        dims: [ 1 ]
      },
      {
        name: "stream"
        data_type: TYPE_BOOL
        dims: [ 1 ]
        optional: true
      },
      {
        name: "sampling_parameters"
        data_type: TYPE_STRING
        dims: [ 1 ]
        optional: true
      },
      {
        name: "exclude_input_in_output"
        data_type: TYPE_BOOL
        dims: [ 1 ]
        optional: true
      }
    ]

    output [
      {
        name: "text_output"
        data_type: TYPE_STRING
        dims: [ -1 ]
      }
    ]
    PBTXT

    cat > "$_model/model-defaults.json" << 'DEFAULTS'
    ${defaultsJson}
    DEFAULTS

    mkdir -p "$out/share/${pname}"
    echo -n "${version}" > "$out/share/${pname}/flox-build-version-${toString buildMeta.build_version}"
  '';
}
