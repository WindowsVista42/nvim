local on_attach = function(client, bufnr)
  require('completion').on_attach()

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>le', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>lj', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>lm', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ln', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>lc', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end

local opts = {
  tools = { -- rust-tools options
    autoSetHints = true,

    hover_with_actions = true,

    runnables = {
      use_telescope = true
    },

    inlay_hints = {
      show_parameter_hints = true,

      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",

      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7
    },

    hover_actions = {
      border = {
        {"┌", "FloatBorder"}, {"─", "FloatBorder"},
        {"┐", "FloatBorder"}, {"│", "FloatBorder"},
        {"┘", "FloatBorder"}, {"─", "FloatBorder"},
        {"└", "FloatBorder"}, {"│", "FloatBorder"}
      },

      auto_focus = false
    }
  },

  server = {} -- rust-analyer options
}

require('rust-tools').setup(opts)

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Code actions
capabilities.textDocument.codeAction = {
  dynamicRegistration = false;
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = {
         "",
         "quickfix",
         "refactor",
         "refactor.extract",
         "refactor.inline",
         "refactor.rewrite",
         "source",
         "source.organizeImports",
        };
      };
    };
}

-- LSPs
local servers = { "rust_analyzer", "clangd", "pyright" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities;
    on_attach = on_attach;
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = true,
      suggestFromUnimportedLibraries = false,
      closingLabels = true,
    };
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          -- Disable inline diagnostics
          virtual_text = false,
        }
      ),
    };
  }
end

-- Sumneko Lua specific setup
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp["sumneko_lua"].setup {
  capabilities = capabilities;
  on_attach = on_attach;
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = false,
    closingLabels = true,
  };
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable inline diagnostics
        virtual_text = false,
      }
    ),
  };
  settings = {
  Lua = {
    runtime = {
    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    version = 'LuaJIT',
    -- Setup your lua path
    path = runtime_path,
    },
    diagnostics = {
    -- Get the language server to recognize the `vim` global
    globals = {'vim'},
    },
    workspace = {
    -- Make the server aware of Neovim runtime files
    library = vim.api.nvim_get_runtime_file("", true),
    },
    -- Do not send telemetry data containing a randomized but unique identifier
    telemetry = {
    enable = false,
    },
  },
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c", "cpp", "lua", "rust", "haskell", "python", "make", "cmake", "bash", "fish", "comment",
    "glsl", "help", "markdown", "ninja", "regex", "todotxt", "toml", "vim", "yaml"
  },
  sync_install = false,
  highlight = {
    enable = true,
    -- Setting this to false disables vim's default hightlighting
    additional_vim_regex_highlighting = false,
  },
}

require('nvim-treesitter.highlight').set_custom_captures {
  ["Todo"] = "Identifier",
  ["Note"] = "Identifier",
  ["Bug"]  = "Identifier",
}
