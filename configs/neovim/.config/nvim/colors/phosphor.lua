vim.opt.background = "dark"
vim.g.colors_name = "phosphor"

local c = {
  bg         = "#050907",
  bg2        = "#0B1410",
  green      = "#55E17A",
  bright     = "#A0FFB2",
  dim        = "#286B45",
  amber      = "#FFB84D",
  red        = "#FF5C5C",
  muted      = "#77917E",
}

local groups = {
  -- Editor
  Normal          = { fg = c.green, bg = c.bg },
  NormalFloat     = { fg = c.green, bg = c.bg2 },
  FloatBorder     = { fg = c.dim, bg = c.bg2 },
  Cursor          = { fg = c.bg, bg = c.bright },
  CursorLine      = { bg = c.bg2 },
  CursorLineNr    = { fg = c.bright, bg = c.bg2, bold = true },
  LineNr          = { fg = c.dim, bg = c.bg },
  SignColumn      = { fg = c.dim, bg = c.bg },
  Visual          = { fg = c.bg, bg = c.green },
  Search          = { fg = c.bg, bg = c.amber },
  IncSearch       = { fg = c.bg, bg = c.bright },
  Pmenu           = { fg = c.green, bg = c.bg2 },
  PmenuSel        = { fg = c.bg, bg = c.green },
  StatusLine      = { fg = c.green, bg = c.bg2 },
  StatusLineNC    = { fg = c.muted, bg = c.bg },
  VertSplit       = { fg = c.dim, bg = c.bg },
  WinSeparator    = { fg = c.dim, bg = c.bg },

  -- Syntax
  Comment         = { fg = c.muted, italic = true },
  Constant        = { fg = c.amber },
  String          = { fg = c.green },
  Character       = { fg = c.green },
  Number          = { fg = c.amber },
  Boolean         = { fg = c.amber },
  Identifier      = { fg = c.green },
  Function        = { fg = c.bright },
  Statement       = { fg = c.bright },
  Keyword         = { fg = c.bright },
  Type            = { fg = c.green },
  Special         = { fg = c.amber },
  PreProc         = { fg = c.dim },
  Todo            = { fg = c.bg, bg = c.amber, bold = true },

  -- Treesitter
  ["@comment"]           = { link = "Comment" },
  ["@string"]            = { link = "String" },
  ["@number"]            = { link = "Number" },
  ["@constant"]          = { link = "Constant" },
  ["@function"]          = { link = "Function" },
  ["@function.call"]     = { link = "Function" },
  ["@keyword"]           = { link = "Keyword" },
  ["@type"]              = { link = "Type" },
  ["@variable"]          = { fg = c.green },
  ["@operator"]          = { fg = c.bright },
  ["@punctuation"]       = { fg = c.dim },

  -- Diagnostics and diff
  DiagnosticError       = { fg = c.red },
  DiagnosticWarn        = { fg = c.amber },
  DiagnosticInfo        = { fg = c.green },
  DiagnosticHint        = { fg = c.dim },
  DiffAdd               = { fg = c.green, bg = c.bg2 },
  DiffChange            = { fg = c.amber, bg = c.bg2 },
  DiffDelete            = { fg = c.red, bg = c.bg2 },
  DiffText              = { fg = c.bright, bg = c.bg2 },
}

for group, opts in pairs(groups) do
  vim.api.nvim_set_hl(0, group, opts)
end

