vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.neovide_cursor_animation_length = 0
vim.o.guifont = 'Consolas Nerd Font:h11'
vim.g.neovide_scroll_animation_length = 0.1

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.swapfile = false
vim.opt.confirm = true

vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'

--vim.opt.shell = 'bash -l'
vim.opt.shell = 'msys2_shell.cmd -defterm -here -no-start -mingw64 -use-full-path'
vim.opt.shellcmdflag = '-c'
vim.opt.shellslash = true
vim.opt.shellxquote = ''

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.fillchars = {
    fold = ' ',
}
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldnestmax = 20

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
    {
        'nvim-mini/mini.icons',
        config = function()
            require('mini.icons').setup {}
        end,
    },
    {
        'nvim-mini/mini.move',
        config = function()
            require('mini.move').setup {
                mappings = {
                    left = '<a-left>',
                    right = '<a-right>',
                    down = '<a-down>',
                    up = '<a-up>',
                    line_left = '<a-left>',
                    line_right = '<a-right>',
                    line_down = '<a-down>',
                    line_up = '<a-up>',
                },
            }
        end,
    },
    {
        'nvim-mini/mini.pairs',
        config = function()
            require('mini.pairs').setup {}
        end,
    },
    {
        'nvim-mini/mini.surround',
        config = function()
            require('mini.surround').setup {}
        end,
    },
    {
        'nvim-mini/mini.statusline',
        config = function()
            require('mini.statusline').setup {}
        end,
    },
    {
        'pogyomo/winresize.nvim',
    },
    {
        'Mofiqul/vscode.nvim',
        'RostislavArts/naysayer.nvim',
    },
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
    {
        'github/copilot.vim',
        tag = 'v1.52.0',
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
            },
        },
        opts = {
            notify_on_error = false,
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'black' },
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
            },
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
            },

            auto_install = true,
            highlight = {
                enable = false,
            },
            indent = { enable = false },
        },
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
        'tpope/vim-fugitive',
    },
    {
        'junegunn/fzf',
        'junegunn/fzf.vim',
        'tracyone/fzf-funky',
    },
}

vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuOpen',
    callback = function()
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
--custom commmands
local term_buf = nil
local term_win = nil

local resize = function(win, amt, dir)
    return function()
        require('winresize').resize(win, amt, dir)
    end
end

generate_compile_flags_from_vscode = function(force)
    local settings_path = vim.fn.getcwd() .. '/.vscode/c_cpp_properties.json'
    local compile_flags_path = vim.fn.getcwd() .. '/compile_flags.txt'
    if vim.fn.filereadable(settings_path) == 0 then
        return
    end
    if vim.fn.filereadable(compile_flags_path) == 1 and force == false then
        return
    end
    print 'Generating compile_flags.txt from .vscode/c_cpp_properties.json...'
    local keys = vim.api.nvim_replace_termcodes('<leader>ti', true, false, true)
    vim.api.nvim_feedkeys(keys, 'm', false)
    keys = vim.api.nvim_replace_termcodes('convert-flags.sh .vscode/c_cpp_properties.json<cr>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'm', false)
end

vim.cmd [[
  function! FzfProjectSink(path)
    execute 'cd ' . a:path
    silent! bufdo bwipeout!
    term_win = nil
    term_buf = nil
    enew
  endfunction
]]

vim.cmd [[
  function! FzfChangeProject(cmd)

    let l:cwd = getcwd()
    let l:drive = matchstr(l:cwd, '^([A-Za-z]:)')
    let l:find_command = 'fd --type d --hidden --full-path "" ' . l:drive . '/'
    "let l:cleanup_sink = 'cd | silent! bufdo bwipeout!'
    call fzf#run(fzf#wrap({
      \ 'source': l:find_command,
      \ 'sink': function('FzfProjectSink'),
      \ 'options': '--prompt="Select Folder > "'
      \ }))
  endfunction
]]

-- vim.cmd('bufdo bwipeout!')
-- Define the user command that calls the function
vim.api.nvim_create_user_command(
    'CDProject', -- The name of the Neovim command (e.g., :CDProject)
    'call FzfChangeProject("")', -- The Vimscript to execute
    {
        desc = 'Fuzzy-find and change to a new project directory',
        bang = false,
        nargs = 0, -- Takes no arguments
    }
)

function ToggleTerminal()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
    else
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
            vim.cmd('botright sbuf ' .. term_buf)
        else
            vim.cmd 'botright split | term'
            term_buf = vim.api.nvim_get_current_buf()
        end
        term_win = vim.api.nvim_get_current_win()
        vim.cmd 'startinsert'
    end
end

-- Optional: Create a quick key mapping for the new command
vim.keymap.set('n', '<leader>cp', '<cmd>CDProject<CR>')
--theme

local color_1 = "Green"
local color_2 = "Blue"
local color_3 = "Blue"
local color_4 = "Red"
local color_5 = "Yellow"
local color_background = "#e0e0e0"
local color_foreground = "Black"

vim.opt.background = 'light'
vim.cmd.colorscheme 'quiet'
vim.api.nvim_set_hl(0, 'Normal', { fg = color_foreground, bg = color_background })
vim.api.nvim_set_hl(0, "LineNr", { fg = color_foreground })

vim.api.nvim_set_hl(0, 'Comment', { fg = color_1 })
vim.api.nvim_set_hl(0, "String", { fg = color_1 })
vim.api.nvim_set_hl(0, "Character", { fg = color_1 })

vim.api.nvim_set_hl(0, "Conditional", { fg = color_2 })
vim.api.nvim_set_hl(0, "Repeat", { fg = color_2 })
vim.api.nvim_set_hl(0, "Label", { fg = color_2 })
vim.api.nvim_set_hl(0, "MatchParen", { fg = color_2, bold = true })
vim.api.nvim_set_hl(0, "Exception", { fg = color_2 })
vim.api.nvim_set_hl(0, "Statement", { fg = color_2 })
vim.api.nvim_set_hl(0, "Keyword", { fg = color_2 })

vim.api.nvim_set_hl(0, "Type", { fg = color_3 })
vim.api.nvim_set_hl(0, "StorageClass", { fg = color_3 })
vim.api.nvim_set_hl(0, "Structure", { fg = color_3 })
vim.api.nvim_set_hl(0, "Typedef", { fg = color_3 })

vim.api.nvim_set_hl(0, "PreProc", { fg = color_3 })
vim.api.nvim_set_hl(0, "Include", { fg = color_3 })
vim.api.nvim_set_hl(0, "Define", { fg = color_3 })
vim.api.nvim_set_hl(0, "Macro", { fg = color_3 })
vim.api.nvim_set_hl(0, "PreCondit", { fg = color_3 })

vim.api.nvim_set_hl(0, "Todo", { fg = color_4 })
vim.api.nvim_set_hl(0, "Error", { fg = color_4 })

vim.api.nvim_set_hl(0, "Visual", { bg = color_5 })

--basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

--movement keymaps
vim.keymap.set('n', '<c-w><c-left>', '<c-w><c-h>')
vim.keymap.set('n', '<c-w><c-right>', '<c-w><c-l>')
vim.keymap.set('n', '<c-w><c-down>', '<c-w><c-j>')
vim.keymap.set('n', '<c-w><c-up>', '<c-w><c-k>')

--scrolling
vim.keymap.set('n', '<c-up>', '<c-u>')
vim.keymap.set('n', '<c-down>', '<c-d>')

--indent
vim.keymap.set('n', '<tab>', '>>')
vim.keymap.set('n', '<s-tab>', '<<')
vim.keymap.set('v', '<tab>', '>gv')
vim.keymap.set('v', '<s-tab>', '<gv')
vim.keymap.set('i', '<s-tab>', '<backspace>')

--delete shift + arrows
vim.keymap.set('v', '<s-left>', '')
vim.keymap.set('v', '<s-right>', '')
vim.keymap.set('v', '<s-down>', '')
vim.keymap.set('v', '<s-up>', '')

--normal-mode commands
vim.keymap.set('n', 'g<right>', '$')
vim.keymap.set('n', 'g<left>', '0')
vim.keymap.set('n', 'g<up>', 'gg')
vim.keymap.set('n', 'g<down>', '<s-g>')

--visual-mode commands
vim.keymap.set('v', 'g<right>', '$')
vim.keymap.set('v', 'g<left>', '0')
vim.keymap.set('v', 'g<up>', 'gg')
vim.keymap.set('v', 'g<down>', '<s-g>')

vim.keymap.set('n', '<S-Left>', resize(0, 2, 'left'))
vim.keymap.set('n', '<S-Down>', resize(0, 2, 'down'))
vim.keymap.set('n', '<S-Up>', resize(0, 2, 'up'))
vim.keymap.set('n', '<S-Right>', resize(0, 2, 'right'))

vim.keymap.set('n', '<leader>t', ToggleTerminal)
vim.keymap.set('n', '<leader>e', ':Oil<cr>')

vim.keymap.set('n', '<leader>q', ':cwindow<cr>')
vim.keymap.set('n', '<leader>d', ':bd<cr>')
vim.keymap.set('n', '<leader>sf', ':Files<cr>')
vim.keymap.set('n', '<leader>sg', ':RG<cr>')
vim.keymap.set('n', '<leader>su', ':FzfFunky<cr>')
vim.keymap.set('n', '<leader><leader>', ':Buffers<cr>')
vim.keymap.set('n', '<leader>sh', ':Helptags<cr>')
vim.keymap.set('n', '<leader>gc', function()
    generate_compile_flags_from_vscode(true)
end)
vim.keymap.set('n', '<leader>g', ':Git<cr>')
vim.keymap.set('n', '<leader>c', ':CDProject<cr>')

generate_compile_flags_from_vscode(false)

vim.g.fzf_layout = { down = '40%' }
vim.api.nvim_create_user_command('W', ':w', { desc = 'Save file with capslock on' })
vim.api.nvim_create_user_command('Q', ':q', { desc = 'Quit file with capslock on' })
