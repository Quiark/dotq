self: super:
{
	luajit_gc64 = super.luajit_2_1.overrideAttrs (oldAttrs: rec {
		makeFlags = oldAttrs.makeFlags ++ ["XCFLAGS=-DLUAJIT_ENABLE_GC64"];

	});
	minetest = super.minetestclient_5.override {
		luajit = self.luajit_gc64;

	};
}
