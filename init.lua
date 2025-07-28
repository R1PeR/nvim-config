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

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

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
                { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>r', group = '[R]ename' },
                { '<leader>s', group = '[S]earch' },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
            },
        },
    },
    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true, -- Enable preview of colors in the picker
                        theme = 'ivy', -- Use a dropdown theme for the picker
                    },
                    find_files = {
                        hidden = true, -- Show hidden files
                        no_ignore = true, -- Show files ignored by .gitignore
                        theme = 'ivy', -- Use a dropdown theme for the picker
                        path_display = { 'truncate' },
                    },
                    grep_string = {
                        additional_args = function()
                            return { '--hidden' } -- Include hidden files in grep
                        end,
                        theme = 'ivy', -- Use a dropdown theme for the picker
                        path_display = { 'truncate' },
                    },
                    live_grep = {
                        additional_args = function()
                            return { '--hidden' } -- Include hidden files in live grep
                        end,
                        theme = 'ivy', -- Use a dropdown theme for the picker
                        path_display = { 'truncate' },
                    },
                    buffers = {
                        sort_lastused = true, -- Sort buffers by last used
                        theme = 'ivy', -- Use a dropdown theme for the picker
                        path_display = { 'truncate' },
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end,
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
                desc = '[f]ormat buffer',
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
            require("oil").setup()
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

--lsp
local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'LSP: ' .. desc })
end

-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.
map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

-- Find references for the word under your cursor.
map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

-- Fuzzy find all the symbols in your current workspace.
--  Similar to document symbols, except searches over your entire project.
map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

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
vim.keymap.set('n', '<s-left>', '')
vim.keymap.set('n', '<s-right>', '')
vim.keymap.set('n', '<s-down>', '')
vim.keymap.set('n', '<s-up>', '')
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
vim.o.shellxquote = '('

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

--custom commmands
vim.keymap.set('n', '<leader>t', ':sp<bar>term<cr><c-w>J:resize10<cr>', { desc = '[T]erminal' })

--oil.nvim

vim.keymap.set('n', '<leader>e', ':Oil<cr>', { desc = '[E]xplorer' })
