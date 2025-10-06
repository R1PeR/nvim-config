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
        'github/copilot.vim',
        'Mofiqul/vscode.nvim',
        'stevearc/oil.nvim',
    },
}
require('oil').setup {
    view_options = {
        show_hidden = true,
    },
}

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
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

vim.opt.grepprg = 'rg --smart-case --type "c" --type "cpp" --type "py" --vimgrep $* **'
-- vim.opt.grepprg = 'ag --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
-- command! -args=+ Grep execute 'silent grep! <args>' | copen 42

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "*grep*",
    group = vim.api.nvim_create_augroup('QuickFixAutoOpen', { clear = true }),
    command = "cwindow",
    desc = "Open location window after command like :lgrep, :lmake",
})

vim.cmd.colorscheme 'vscode'

vim.o.shell = 'bash'
vim.o.shellcmdflag = '-c'
vim.o.shellslash = true
vim.o.shellxquote = ''

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.opt.path:append('**') 

vim.keymap.set('n', '<c-up>', '<c-u>zz')
vim.keymap.set('n', '<c-down>', '<c-d>zz')

vim.keymap.set('n', '<tab>', '>>')
vim.keymap.set('n', '<s-tab>', '<<')
vim.keymap.set('v', '<tab>', '>gv')
vim.keymap.set('v', '<s-tab>', '<gv')

vim.keymap.set('v', '<s-left>', '')
vim.keymap.set('v', '<s-right>', '')
vim.keymap.set('v', '<s-down>', '')
vim.keymap.set('v', '<s-up>', '')

vim.keymap.set('n', 'g<right>', '$')
vim.keymap.set('n', 'g<left>', '0')
vim.keymap.set('n', 'g<up>', 'gg')
vim.keymap.set('n', 'g<down>', '<s-g>')

vim.keymap.set('v', 'g<right>', '$')
vim.keymap.set('v', 'g<left>', '0')
vim.keymap.set('v', 'g<up>', 'gg')
vim.keymap.set('v', 'g<down>', '<s-g>')

vim.keymap.set('n', '<leader>t', ':sp<bar>term<cr><c-w>J:resize10<cr>')
vim.keymap.set('n', '<leader>sf', ':find ')
vim.keymap.set('n', '<leader>sg', ':silent grep! ')
vim.keymap.set('n', '<leader>e', ':Oil<cr>')
vim.keymap.set('n', '<leader><leader>', ':buffers<cr>:buffer ')
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>q', ':cw<cr>')

vim.keymap.set('n', '<S-Left>', '<C-w><')
vim.keymap.set('n', '<S-Down>', '<C-w>-')
vim.keymap.set('n', '<S-Up>', '<C-w>+')
vim.keymap.set('n', '<S-Right>', '<C-w>>')

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
