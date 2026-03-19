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
  slug = "HuggingFaceTB--SmolLM3-3B-FP8-TORCHAO";
  snapshotId = "7e79e7b04e4b2f58d723291c3016f22b26ab177c";
}
