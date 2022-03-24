self: super:
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    NIX_LDFLAGS = [];
  });

}
