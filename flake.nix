{
  description = "SDDM themes cá nhân";

  outputs = { self }: {
    nixosModules.default = ./module.nix;
  };
}