self: super:
{
    # luajit_gc64 = super.luajit_2_1.overrideAttrs (oldAttrs: rec {
    #	makeFlags = oldAttrs.makeFlags ++ ["XCFLAGS=-DLUAJIT_ENABLE_GC64"];
    #});
    #
    
    #luajit_gc64 = import development/interpreters/luajit/2.1.nix {
    #  inherit super.callPackage;
    #};

    luajit_gc64 = self.callPackage <nixpkgs/pkgs/development/interpreters/luajit/default.nix> {
      self = self.luajit_gc64;
      enableGC64 = true;
      version = "2.1.0-2020-08-27";
      rev = "ff1e72a";
      isStable = false;
      owner = "LuaJIT";
      repo = "LuaJIT";
      sha256 = "0rlh5y48jbxnamr3a5i3szzh7y9ycvq052rw6m82gdhrb1jlamdz";
    };

	minetest = super.minetestclient_5.override {
		luajit = self.luajit_gc64;
	};
}
