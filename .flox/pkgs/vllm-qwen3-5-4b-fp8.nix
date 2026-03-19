# Qwen3.5-4B FP8-TORCHAO for vLLM
{ pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:

let
  buildMeta = builtins.fromJSON (builtins.readFile ../../build-meta/vllm-qwen3-5-4b-fp8.json);
in
mkHfModel {
  pname = "vllm-qwen3.5-4b-fp8";
  baseVersion = "1.0.0";
  inherit buildMeta;
  srcPath = /mnt/scratch/models/inferencing/hub/models--Qwen--Qwen3.5-4B-FP8-TORCHAO/snapshots/cbd334b0c03d4ef0e42ba39772bad7dd86ddfb3d;
  tritonModelName = "qwen3_5_4b_fp8";
  vllmDefaults = {
    gpu_memory_utilization = 0.85;
    max_model_len = 4096;
    dtype = "auto";
    enable_log_requests = false;
  };
}
