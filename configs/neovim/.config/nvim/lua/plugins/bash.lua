return {
  -- tell mason to auto-install theese tools if not present
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shellcheck",
        "shfmt",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "bash" })
    end,
  },

  -- wire bash-language-server into nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          -- bash-language-server uses shellcheck internally for diagnostics
          -- but we also run shellcheck via none-ls for more control
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command|.bashrc|.bash_profile|.bash_alias)",
            },
          },
        },
      },
    },
  },

  -- formatting via conform.nvim {LazyVim's formatter layer}
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          -- -i 4: 4-space indent
          -- -ci: indent case statements
          prepend_args = { "-i", "4", "-ci" },
        },
      },
    },
  },

  -- Linting via nvim-lint (LazyVim's linter layer)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
