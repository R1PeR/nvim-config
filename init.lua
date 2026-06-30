require('vim._core.ui2').enable { enable = true }
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.neovide_cursor_animation_length = 0
vim.o.guifont = 'MartianMono Nerd Font:h11'
vim.g.neovide_scroll_animation_length = 0.1

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.showmode = false

vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'

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

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.swapfile = false
vim.opt.confirm = true

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.iskeyword:remove '_'

vim.opt.completeopt = {'fuzzy', 'menu', 'menuone', 'noinsert', 'popup', 'preview' }
vim.opt.autocomplete = false
vim.opt.autocompletedelay = 250

vim.opt.wildoptions = 'fuzzy,pum'
vim.opt.wildmode = 'longest:full,full'
vim.opt.wildignore:append {
    '*/node_modules/*',
    '*/.git/*',
    '*/.vscode/*',
    '*/dist/*',
    '*.o',
    '*.obj',
    '*.d',
}

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
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
            vim.lsp.completion.enable(true, client.id, ev.buf)
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

local term_buf = nil
local term_win = nil

function ToggleTerminal()
    -- Case 1: The terminal window is currently open and valid
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        -- If we are currently inside the terminal window, just hide it
        if vim.api.nvim_get_current_win() == term_win then
            vim.api.nvim_win_hide(term_win)
            term_win = nil
        else
            -- If we are in a different window, jump INTO the terminal window
            vim.api.nvim_set_current_win(term_win)
            vim.cmd 'startinsert'
        end
    else
        -- Case 2: Window is not open. Check if we have an existing, valid terminal buffer
        if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
            -- Check if the buffer is actually still a terminal (hasn't been exited)
            if vim.bo[term_buf].buftype == 'terminal' then
                vim.cmd('botright sbuf ' .. term_buf)
            else
                -- The shell process exited inside the buffer; spawn a new one
                vim.cmd 'botright split | term'
                term_buf = vim.api.nvim_get_current_buf()
            end
        else
            -- Case 3: No valid buffer exists at all, create a brand new one
            vim.cmd 'botright split | term'
            term_buf = vim.api.nvim_get_current_buf()
        end

        -- Track the newly opened window and drop into insert mode
        term_win = vim.api.nvim_get_current_win()
        vim.cmd 'startinsert'
    end
end

vim.pack.add {
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/tpope/vim-fugitive',
    {
        src = 'https://github.com/github/copilot.vim',
        version = 'v1.52.0',
    },
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/pogyomo/winresize.nvim',
    'https://github.com/nvim-mini/mini.surround',
    'https://github.com/nvim-mini/mini.pairs',
    'https://github.com/nvim-mini/mini.pick',
    'https://github.com/nvim-mini/mini.move',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('oil').setup {
    view_options = {
        show_hidden = true,
    },
}

require('conform').setup {
    notify_on_error = false,
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
}

require('nvim-treesitter').setup {
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
}

require('fzf-lua').setup {
    winopts = {
        height = 0.30, -- 30% screen height
        width = 1.00, -- Full width
        row = 1.00, -- Stick to bottom
        col = 0.00,
        preview = { hidden = true }, -- Disable preview window
    },
}

require('mini.move').setup {
    mappings = {
        left = '<M-Left>',
        right = '<M-Right>',
        down = '<M-Down>',
        up = '<M-Up>',
        line_left = '<M-Left>',
        line_right = '<M-Right>',
        line_down = '<M-Down>',
        line_up = '<M-Up>',
    },
}

require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.pick').setup {
    window = {
        config = function()
            local height = math.floor(vim.o.lines / 2)
            return {
                anchor = 'NW',
                height = height,
                width = vim.o.columns,
                row = vim.o.lines - height - 2,
                col = 0,
            }
        end,
    },
}

function Format()
    require('conform').format { async = true, lsp_format = 'fallback' }
end

function GenerateFdCache()
    local cwd = vim.fn.getcwd()
    local drive = cwd:sub(1, 1) or '/'
    print('Regenerating fd cache for drive ' .. drive)
    local cache_file = vim.fn.expand('~/.fd_cache_' .. drive .. '.txt')
    local command_fd = { 'fd', '--type', 'd', '--hidden', '--exclude', '.git', '--color', 'never', '.', drive .. ':/' }
    local fd_output = vim.fn.systemlist(command_fd)
    if vim.v.shell_error ~= 0 then
        print('Error generating fd cache: ' .. table.concat(fd_output, '\n'))
        return
    end
    vim.fn.writefile(fd_output, cache_file)
end

vim.api.nvim_create_user_command('FDCache', GenerateFdCache, {})

function PickChangeDirectory()
    local pick = require 'mini.pick'
    local cwd = vim.fn.getcwd()
    local drive = cwd:sub(1, 1) or '/'
    local cache_file = vim.fn.expand('~/.fd_cache_' .. drive .. '.txt')

    if (vim.fn.filereadable(cache_file)) == 0 then
        print('Generating fd cache for drive ' .. drive .. '...')
        GenerateFdCache()
    else
        local cache_mtime = vim.fn.getftime(cache_file)
        local disk_mtime = vim.fn.getftime(drive .. ':/')
        if cache_mtime < disk_mtime then
            GenerateFdCache()
        end
    end

    local cache_list = vim.fn.readfile(cache_file)
    cache_list = cache_list or {}
    pick.start {
        source = {
            items = cache_list,
            name = 'Change Directory (' .. drive .. ')',
            choose = function(item)
                if item then
                    vim.cmd('cd ' .. vim.fn.fnameescape(item))
                    print('CWD changed to: ' .. vim.fn.getcwd())

                    vim.cmd 'silent! bufdo bwipeout!'
                    _G.term_win = nil
                    _G.term_buf = nil
                    vim.cmd 'enew'
                end
            end,
        },
    }
end

vim.keymap.set('n', '<leader>sf', ':Pick files<cr>')
vim.keymap.set('n', '<leader>sg', ':Pick grep_live<cr>')
vim.keymap.set('n', '<leader>c', PickChangeDirectory)
vim.keymap.set('n', '<leader><leader>', ':Pick buffers<cr>')
vim.keymap.set('n', '<leader>e', ':Oil<cr>')
vim.keymap.set('n', '<leader>g', ':Git<cr>')
vim.keymap.set('n', '<leader>t', ToggleTerminal)
vim.keymap.set('n', '<leader>f', Format)
vim.keymap.set('v', '<leader>f', Format)

vim.cmd.colorscheme 'catppuccin'
vim.opt.background = 'dark'

function getMode()
    local mode = vim.fn.mode()
    local mode_map = {
        ['n'] = 'NORMAL',
        ['i'] = 'INSERT',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['c'] = 'COMMAND',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        [''] = 'S-BLOCK',
        ['t'] = 'TERMINAL',
    }
    return mode_map[mode] or mode
end

vim.opt.statusline = '[%{%v:lua.getMode()%}] [%n] %f %m %r'

local resize = function(win, amt, dir)
    return function()
        require('winresize').resize(win, amt, dir)
    end
end

vim.keymap.set('n', '<S-Left>', resize(0, 2, 'left'))
vim.keymap.set('n', '<S-Down>', resize(0, 2, 'down'))
vim.keymap.set('n', '<S-Up>', resize(0, 2, 'up'))
vim.keymap.set('n', '<S-Right>', resize(0, 2, 'right'))
vim.keymap.set('n', '<c-up>', '<c-u>')
vim.keymap.set('n', '<c-down>', '<c-d>')

local fontSize = 11
function adjustFontSize(delta)
    fontSize = fontSize + delta
    vim.opt.guifont = 'MartianMono Nerd Font:h' .. fontSize
end

vim.keymap.set('n', '<PageDown>', function()
    adjustFontSize(1)
end)
vim.keymap.set('n', '<PageUp>', function()
    adjustFontSize(-1)
end)
