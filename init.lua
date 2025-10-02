-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.netrw_liststyle = 3
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.swapfile = false -- Disable swap files

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            -- delay between pressing a key and opening which-key (milliseconds)
            -- this setting is independent of vim.opt.timeoutlen
            delay = 0,
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                -- { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
                -- { '<leader>d', group = '[D]ocument' },
                -- { '<leader>r', group = '[R]ename' },
                { '<leader>s', group = '[S]earch' },
                -- { '<leader>w', group = '[W]orkspace' },
                -- { '<leader>t', group = '[T]oggle' },
                -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'cpp',
                'diff',
                'python',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'vim',
                'vimdoc',
                'gitcommit',
                'git_rebase',
                'git_config',
            },

            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = { enable = false },
        },
    },
    {
        'm4xshen/autoclose.nvim',
        config = function()
            require('autoclose').setup {}
        end,
    },
    {
        'fedepujol/move.nvim',
        config = function()
            require('move').setup {}
        end,
    },
    {
        'martinsione/darkplus.nvim',
        'unrealjo/neovim-purple',
        'Mofiqul/vscode.nvim',
        'folke/tokyonight.nvim',
        'Verf/deepwhite.nvim',
        'slugbyte/lackluster.nvim',
        'Mofiqul/vscode.nvim',
        'rakr/vim-one',
        'NLKNguyen/papercolor-theme',
        'sainnhe/everforest',
        'projekt0n/github-nvim-theme',
        'sainnhe/sonokai',
        'sainnhe/gruvbox-material',
        'sainnhe/edge',
        'jnz/studio98',
        'savq/melange',
        'thallada/farout.nvim',
        'martinsione/darkplus.nvim',
        'wnkz/monoglow.nvim',
        'dasupradyumna/midnight.nvim',
        'metalelf0/jellybeans-nvim',
    },
    {
        'NStefan002/visual-surround.nvim',
        config = function()
            require('visual-surround').setup {
                enable_wrapped_deletion = true,
            }
            -- [optional] custom keymaps
        end,
    },
    { -- autoformat
        'stevearc/conform.nvim',
        event = { 'bufwritepre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. you can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- conform can also run multiple formatters sequentially
                python = { 'isort', 'black' },
                --
                -- you can use 'stop_after_first' to run the first available formatter from the list
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
            },
        },
    },
    {
        'github/copilot.vim',
    },
    { -- Autocompletion
        'Saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            -- Snippet Engine
            {
                'L3MON4D3/LuaSnip',
                version = '2.*',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {},
                opts = {},
            },
            'folke/lazydev.nvim',
            -- 'fang2hou/blink-copilot',
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'none',
                ['<CR>'] = { 'accept', 'fallback' },
                ['<Tab>'] = { 'accept', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
            },

            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
                trigger = {
                    prefetch_on_insert = true,
                },
                ghost_text = { enabled = true },
                list = { selection = { preselect = false, auto_insert = true } },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },

            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'mono',
            },

            snippets = { preset = 'luasnip' },
            fuzzy = { implementation = 'prefer_rust_with_warning' },
            signature = { enabled = true },
        },
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup {
                view_options = {
                    show_hidden = true,
                },
            }
        end,
    },
    {
        'pogyomo/winresize.nvim',
    },
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('fzf-lua').setup {
                { 'fzf-native' },
                winopts = {
                    height = 0.4,
                    width = 1,
                    row = 1,
                    col = 0,
                    border = 'border-top',
                    backdrop = 100,
                    preview = {
                        delay = 0,
                        border = 'border-top',
                        default = 'builtin',
                    },
                },
            }
        end,
    },
}

vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuOpen',
    callback = function()
        -- require('copilot.suggestion').dismiss()
        vim.b.copilot_suggestion_hidden = true
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuClose',
    callback = function()
        vim.b.copilot_suggestion_hidden = false
    end,
})

vim.lsp.config.clangd = {
    cmd = { 'clangd', '--background-index' },
    root_markers = { 'compile_flags.txt', 'compile_commands.json' },
    filetypes = { 'c', 'cpp', 'h', 'hpp' },
}

vim.lsp.enable { 'clangd' }

vim.lsp.config.lua_ls = {
    cmd = {
        'lua-language-server',
    },
    root_markers = {
        '.git',
        '.luacheckrc',
        '.luarc.json',
        '.luarc.jsonc',
        '.stylua.toml',
        'selene.toml',
        'selene.yml',
        'stylua.toml',
    },
    filetype = {
        'lua',
    },
    single_file_support = true,
}
vim.lsp.enable { 'lua_ls' }

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method 'textDocument/completion' then
            vim.lsp.completion.enable(false, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

vim.diagnostic.config {
    virtual_text = { current_line = true },
}

vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    } or {},
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
}
--theme
vim.o.background = 'dark'
vim.cmd.colorscheme 'vscode'

--movement keymaps
vim.keymap.set('n', '<c-w><c-left>', '<c-w><c-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<c-w><c-right>', '<c-w><c-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<c-w><c-down>', '<c-w><c-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<c-w><c-up>', '<c-w><c-k>', { desc = 'Move focus to the upper window' })

--scrolling
vim.keymap.set('n', '<c-up>', '<c-u>')
vim.keymap.set('n', '<c-down>', '<c-d>')

--save
vim.keymap.set('n', '<c-s>', ':w<cr>')
vim.keymap.set('i', '<c-s>', '<esc>:w<cr><i>')

--indent
vim.keymap.set('n', '<tab>', '>>')
vim.keymap.set('n', '<s-tab>', '<<')
vim.keymap.set('v', '<tab>', '>gv')
vim.keymap.set('v', '<s-tab>', '<gv')

--mini.move
vim.keymap.set('n', '<m-left>', '<m-h>')
vim.keymap.set('n', '<m-right>', '<m-l>')
vim.keymap.set('n', '<m-down>', '<m-j>')
vim.keymap.set('n', '<m-up>', '<m-k>')
vim.keymap.set('v', '<m-left>', '<m-h>')
vim.keymap.set('v', '<m-right>', '<m-l>')
vim.keymap.set('v', '<m-down>', '<m-j>')
vim.keymap.set('v', '<m-up>', '<m-k>')

--delete shift + arrows
-- vim.keymap.set('n', '<s-left>', '')
-- vim.keymap.set('n', '<s-right>', '')
-- vim.keymap.set('n', '<s-down>', '')
-- vim.keymap.set('n', '<s-up>', '')
vim.keymap.set('v', '<s-left>', '')
vim.keymap.set('v', '<s-right>', '')
vim.keymap.set('v', '<s-down>', '')
vim.keymap.set('v', '<s-up>', '')

--normal-mode commands
vim.keymap.set('n', '<a-j>', ':MoveLine(1)<cr>')
vim.keymap.set('n', '<a-k>', ':MoveLine(-1)<cr>')
vim.keymap.set('n', '<a-h>', ':MoveHChar(-1)<cr>')
vim.keymap.set('n', '<a-l>', ':MoveHChar(1)<cr>')
vim.keymap.set('n', '<a-down>', ':MoveLine(1)<cr>')
vim.keymap.set('n', '<a-up>', ':MoveLine(-1)<cr>')
vim.keymap.set('n', '<a-left>', ':MoveHChar(-1)<cr>')
vim.keymap.set('n', '<a-right>', ':MoveHChar(1)<cr>')
vim.keymap.set('n', 'g<right>', '$')
vim.keymap.set('n', 'g<left>', '0')
vim.keymap.set('n', 'g<up>', 'gg')
vim.keymap.set('n', 'g<down>', '<s-g>')

--visual-mode commands
vim.keymap.set('v', '<a-j>', ':MoveBlock(1)<cr>')
vim.keymap.set('v', '<a-k>', ':MoveBlock(-1)<cr>')
vim.keymap.set('v', '<a-h>', ':MoveHBlock(-1)<cr>')
vim.keymap.set('v', '<a-l>', ':MoveHBlock(1)<cr>')
vim.keymap.set('v', '<a-down>', ':MoveBlock(1)<cr>')
vim.keymap.set('v', '<a-up>', ':MoveBlock(-1)<cr>')
vim.keymap.set('v', '<a-left>', ':MoveHBlock(-1)<cr>')
vim.keymap.set('v', '<a-right>', ':MoveHBlock(1)<cr>')
vim.keymap.set('v', 'g<right>', '$')
vim.keymap.set('v', 'g<left>', '0')
vim.keymap.set('v', 'g<up>', 'gg')
vim.keymap.set('v', 'g<down>', '<s-g>')

--tab movement
vim.keymap.set('n', '<c-w>t<left>', ':tabp<cr>')
vim.keymap.set('n', '<c-w>t<right>', ':tabn<cr>')
vim.keymap.set('n', '<c-w>tn', ':tabnew<cr>')
vim.keymap.set('n', '<c-w>tc', ':tabclose<cr>')

vim.o.shell = 'bash'
vim.o.shellcmdflag = '-c'
vim.o.shellslash = true
vim.o.shellxquote = ''

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

--custom commmands
vim.keymap.set('n', '<leader>t', ':sp<bar>term<cr><c-w>J:resize10<cr>', { desc = '[T]erminal' })
--lazygit?
vim.keymap.set('n', '<leader>g', ':term<cr>ilazygit<cr>', { desc = 'Lazy[G]it' })

--oil.nvim
vim.keymap.set('n', '<leader>e', ':Oil<cr>', { desc = '[E]xplorer' })

--resize windows
local resize = function(win, amt, dir)
    return function()
        require('winresize').resize(win, amt, dir)
    end
end
vim.keymap.set('n', '<S-Left>', resize(0, 2, 'left'))
vim.keymap.set('n', '<S-Down>', resize(0, 2, 'down'))
vim.keymap.set('n', '<S-Up>', resize(0, 2, 'up'))
vim.keymap.set('n', '<S-Right>', resize(0, 2, 'right'))

--lsp keymaps
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })
vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = '[G]oto Code [D]efinition' })
vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = '[G]oto Code [I]mplementation' })
vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = '[G]oto Code [R]eferences' })

--fzf keymaps
vim.keymap.set('n', '<leader>sf', ':FzfLua files<cr>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', ':FzfLua live_grep<cr>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader><leader>', ':FzfLua buffers<cr>', { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sh', ':FzfLua helptags<cr>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', ':FzfLua diagnostics_document<cr>', { desc = '[S]earch [D]iagnostics' })
