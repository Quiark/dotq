local M = {}

function M.setup()
  require'illuminate'.configure({
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        "lsp",
        "treesitter",
      },
      -- delay: delay in milliseconds
      delay = 120,
      -- filetype_overrides: filetype specific overrides.
      -- The keys are strings to represent the filetype while the values are tables that
      -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
      filetype_overrides = {},
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "neogitstatus",
        "Trouble",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },

  })
end

return M
