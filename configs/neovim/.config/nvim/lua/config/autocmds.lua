-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local c = {
      bg = "#050907",
      bg2 = "#0B1410",
      green = "#55E17A",
      bright = "#A0FFB2",
      dim = "#286B45",
      amber = "#FFB84D",
      red = "#FF5C5C",
      muted = "#77917E",
    }

    vim.api.nvim_set_hl(0, "Normal", { fg = c.green, bg = c.bg })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.green, bg = c.bg2 })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = c.bg2 })
    vim.api.nvim_set_hl(0, "LineNr", { fg = c.dim, bg = c.bg })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.bright, bg = c.bg2, bold = true })
    vim.api.nvim_set_hl(0, "Comment", { fg = c.muted, italic = true })
    vim.api.nvim_set_hl(0, "String", { fg = c.green })
    vim.api.nvim_set_hl(0, "Function", { fg = c.bright })
    vim.api.nvim_set_hl(0, "Constant", { fg = c.amber })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.amber })
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.red })
    vim.api.nvim_set_hl(0, "Visual", { fg = c.bg, bg = c.green })
  end,
})

