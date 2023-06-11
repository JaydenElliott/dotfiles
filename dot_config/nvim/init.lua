-----------------
---  PLUGINS  ---
-----------------
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use('kaicataldo/material.vim')
    use('ryanoasis/vim-devicons')
    use('BurntSushi/ripgrep')
    use('mbbill/undotree')
    use('preservim/nerdcommenter')
    use('nvim-lua/popup.nvim')
    use('nvim-lua/plenary.nvim')
    use('nvim-telescope/telescope.nvim')
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use('nvim-treesitter/nvim-treesitter')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            -- yeet the below plugins if cmp gets annoying
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-buffer' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
        }
    }
    use('simrat39/rust-tools.nvim')
    use 'j-hui/fidget.nvim'
    use 'tamton-aquib/staline.nvim'
    use 'theprimeagen/harpoon'
    use { 'alexghergh/nvim-tmux-navigation', config = function()
        require 'nvim-tmux-navigation'.setup {
            disable_when_zoomed = true, -- defaults to false
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                last_active = "<C-\\>",
                next = "<C-Space>",
            }
        }
    end
    }
    use { "voldikss/vim-floaterm" }
end)


require("telescope").load_extension "file_browser"
local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")

local delta_bcommits = previewers.new_termopen_previewer({
    get_command = function(entry)
        return {
            "git",
            "-c",
            "core.pager=delta",
            "-c",
            "delta.side-by-side=false",
            "diff",
            entry.value .. "^!",
            "--",
            entry.current_file,
        }
    end,
})


require("fidget").setup()
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "typescript", "javascript", "sql", "go" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}


------------------
---  Key Maps  ---
------------------
local keymap = vim.keymap
vim.g.mapleader = " "
keymap.set('i', 'kj', '<esc>')
keymap.set('i', 'jk', '<esc>')
keymap.set("n", "<leader>/", vim.cmd.noh, { noremap = true })
keymap.set("n", "<leader>ws", vim.cmd.vsplit, { noremap = true })
keymap.set("n", "<leader>wv", vim.cmd.split, { noremap = true })

-- cursor stays in the center of the screen for a bunch of commands
keymap.set("n", "J", "mzJ`z")
keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })
keymap.set('n', 'n', 'nzz', { noremap = true })
keymap.set('n', '<C-o>', '<C-o>zz', { noremap = true })
keymap.set('n', '<C-i>', '<C-i>zz', { noremap = true })

-- god tier remap
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- generate uuid
keymap.set("n", "<leader>u", ":r !uuidgen|sed 's/.*/\"&\"/'|tr \"[A-Z]\" \"[a-z]\"<CR>")

-- telescope
keymap.set('n', '<C-f><C-f>', ':Telescope find_files<CR>')
keymap.set('n', '<C-f><C-g>', ':Telescope live_grep<CR>')
keymap.set('n', '<C-f><C-d>', ':Telescope diagnostics<CR>')
keymap.set(
    "n",
    "<C-f><C-p>",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)
keymap.set(
    "n",
    "<C-f><C-o>",
    ":Telescope file_browser<CR>",
    { noremap = true }
)

-- harpoon
keymap.set('n', "<leader>ha", require("harpoon.mark").add_file)
keymap.set('n', "<leader>hr", require("harpoon.mark").rm_file)
keymap.set('n', "<leader>hc", require("harpoon.mark").clear_all)
keymap.set('n', "<leader>he", require("harpoon.ui").toggle_quick_menu)
keymap.set('n', "<C-n>", require("harpoon.ui").nav_next)
keymap.set('n', "<C-p>", require("harpoon.ui").nav_prev)

-- floatterm
keymap.set('n', "<C-t><C-t>", "<CMD>FloatermNew --height=0.9 --width=0.8 <CR>")




-----------------
---    SET    ---
-----------------
local set = vim.opt
set.nu = true
set.relativenumber = true
set.clipboard = 'unnamedplus'
set.errorbells = false
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.smartindent = true
set.wrap = false
set.splitright = true
set.splitbelow = true
vim.api.nvim_command('filetype plugin on')
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.config/nvim/undo"
set.undofile = true
set.termguicolors = true
set.scrolloff = 8
set.ignorecase = true
set.smartcase = true -- search is case-insensitive unless you include a capital letter



vim.cmd 'colorscheme material'
vim.g.material_style = 'oceanic'

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end


-----------------
---    LSP    ---
-----------------

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
    lsp.buffer_autoformat()
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = true })
end)


lsp.ensure_installed({
    'tsserver',
    'lua_ls',
    'eslint',
    'rust_analyzer',
    "sqlls",
    "gopls",
    "clangd"
})
lsp.skip_server_setup({ 'rust_analyzer' })
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),

        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        --
        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    },
})



local rt = require("rust-tools")

rt.setup({
    server = {
        on_attach = function(client, bufnr)
            require('rust-tools').inlay_hints.enable()
            -- Hover actions
            client.server_capabilities.semanticTokensProvider = nil
            vim.keymap.set("n", "<C-f><C-h>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<C-f><C-a>", rt.code_action_group.code_action_group, { buffer = bufnr })
            vim.keymap.set("n", "<C-f><C-r>", rt.runnables.runnables, { buffer = bufnr })
        end,
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },

})

-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
   set signcolumn=yes
   autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
   ]])

vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)



require("staline").setup {
    sections = {
        left = {
            '▊', ' ', { 'Evil', ' ' }, ' ',                 -- The mode and evil sign
            'file_size', ' ',                                    -- Filesize
            { 'StalineFile', 'file_name' }, ' '                  -- Filename in different highlight
        },
        mid = { 'lsp' },                                         -- "lsp_name" is still a little buggy
        right = {
            { 'StalineEnc', vim.bo.fileencoding:upper() }, '  ', -- Example for custom section
            { 'StalineEnc', 'cool_symbol' }, ' ',                -- the cool_symbol for your OS
            { 'StalineGit', 'branch' }, ' ', '▊'               -- Branch Name in different highlight
        }
    },
    defaults = {
        bg = "#202328",
        branch_symbol = " "
    },
    mode_colors = {
        n = "#38b1f0",
        i = "#9ece6a", -- etc mode
    }
}

vim.opt.laststatus = 3
vim.cmd [[hi Evil        guifg=#f36365 guibg=#202328]] -- Higlight for Evil symbol
vim.cmd [[hi StalineEnc  guifg=#7d9955 guibg=#202328]] -- Encoding Highlight
vim.cmd [[hi StalineGit  guifg=#8583b3 guibg=#202328]] -- Branch Name Highlight
vim.cmd [[hi StalineFile guifg=#c37cda guibg=#202328]] -- File name Highlight

-- Hide all semantic highlights (use tresitter instead) - this is a hack need to change to use
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
end


require('nvim-tmux-navigation').setup {
    disable_when_zoomed = true -- defaults to false
}
