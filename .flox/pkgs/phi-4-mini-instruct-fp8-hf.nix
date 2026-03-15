# Phi-4-mini-instruct FP8 (HuggingFace format, pytorch/torchao quantized)
{ pkgs, mkHfModel ? pkgs.callPackage ./mkHfModel.nix {} }:

mkHfModel {
  pname = "phi-4-mini-instruct-fp8-hf";
  version = "1.0.2";
  srcPath = /mnt/scratch/models/inferencing/resolved/pytorch--Phi-4-mini-instruct-FP8;
  slug = "pytorch--Phi-4-mini-instruct-FP8";
  snapshotId = "794ed9e467db7b7f533b55c9f05e7693c7db34b4";
}
