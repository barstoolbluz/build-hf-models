# SmolLM3-3B FP8-TORCHAO for vLLM
{ pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:

let
  buildMeta = builtins.fromJSON (builtins.readFile ../../build-meta/vllm-smollm3-3b-fp8.json);
in
mkHfModel {
  pname = "vllm-smollm3-3b-fp8";
  baseVersion = "1.0.0";
  inherit buildMeta;
  srcPath = /mnt/scratch/models/inferencing/hub/models--HuggingFaceTB--SmolLM3-3B-FP8-TORCHAO/snapshots/7e79e7b04e4b2f58d723291c3016f22b26ab177c;
  tritonModelName = "smollm3_3b_fp8";
  vllmDefaults = {
    gpu_memory_utilization = 0.85;
    max_model_len = 4096;
    dtype = "auto";
    enable_log_requests = false;
  };
}
