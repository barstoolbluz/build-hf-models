# Phi-4-mini-instruct FP8 (HuggingFace format, pytorch/torchao quantized)
{ pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:

let
  buildMeta = builtins.fromJSON (builtins.readFile ../../build-meta/phi-4-mini-instruct-fp8-hf.json);
in
mkHfModel {
  pname = "phi-4-mini-instruct-fp8-hf";
  baseVersion = "1.0.2";
  inherit buildMeta;
  srcPath = /mnt/scratch/models/inferencing/resolved/pytorch--Phi-4-mini-instruct-FP8;
  tritonModelName = "phi4_mini_instruct_fp8_hf";
  vllmDefaults = {
    gpu_memory_utilization = 0.85;
    max_model_len = 4096;
    dtype = "auto";
    enable_log_requests = false;
  };
}
