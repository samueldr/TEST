workflow "Build on push" {
  on = "push"
  resolves = ["samueldr/action-nix-build@master-3"]
}

action "samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848" {
  uses = "samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848"
  env = {
    NIXPKGS_ALLOW_UNFREE = "1"
  }
}

workflow "Upload on release" {
  on = "release"
  resolves = [
    "JasonEtco/upload-to-release@v0.1.1",
    "samueldr/action-nix-build@master-1",
    "samueldr/action-nix-build@master-2",
  ]
}

action "samueldr/action-nix-build@master-1" {
  uses = "samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848"
  env = {
    NIXPKGS_ALLOW_UNFREE = "1"
  }
}

action "samueldr/action-nix-build@master-2" {
  uses = "samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848"
  needs = ["samueldr/action-nix-build@master-1"]
  runs = ["sh", "-c", "ls -lA"]
  env = {
    NIXPKGS_ALLOW_UNFREE = "1"
  }
}

action "JasonEtco/upload-to-release@v0.1.1" {
  uses = "JasonEtco/upload-to-release@v0.1.1"
  needs = ["samueldr/action-nix-build@master-2"]
  args = "result/ROC-RK3399-PC-firmware-combined.img.xz"
  secrets = ["GITHUB_TOKEN"]
}

action "samueldr/action-nix-build@master-3" {
  uses = "samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848"
  needs = ["samueldr/action-nix-build@0d97a8a9b611fb440e051078729c93603a8ae848"]
    runs = ["sh", "-c", "ls -lA"]
}

