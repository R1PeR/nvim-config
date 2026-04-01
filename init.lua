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

vim.opt.grepprg = 'rg --vimgrep'
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
vim.opt.iskeyword:remove("_")

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.wildignore:append { 
  "*/node_modules/*", 
  "*/.git/*", 
  "*/.vscode/*", 
  "*/build/*", 
  "*/dist/*", 
  "*.o", 
  "*.obj", 
  "*.d" 
}

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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

local term_buf = nil
local term_win = nil

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

-- vim.pack.del({'blink.cmp'})

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
    {
        src = 'https://github.com/Saghen/blink.cmp',
        version = 'v1.10.1',
    },
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

require('nvim-treesitter').setup{
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

require('fzf-lua').setup({
    winopts = {
        height  = 0.30,   -- 30% screen height
        width   = 1.00,   -- Full width
        row     = 1.00,   -- Stick to bottom
        col     = 0.00,
        -- border  = 'none', -- Minimalist look
        preview = {hidden = true}, -- Disable preview window
    },
})

require('blink.cmp').setup {
    auto_trigger = true,
    debounce = 150,
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
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
}

vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuOpen',
    callback = function()
        vim.b.copilot_hide_during_completion = 0
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'BlinkCmpMenuClose',
    callback = function()
        vim.b.copilot_hide_during_completion = 1
    end,
})

function Format()
    require('conform').format { async = true, lsp_format = 'fallback' }
end

function FzfChangeDirectory()
    local fzf = require("fzf-lua")

    cwd = vim.fn.getcwd()
    drive = vim.fn.matchstr(cwd, '^([A-Za-z]:)')
    if drive == "" then drive = "/" end
    local find_command = "fd --type d --hidden --exclude .git --color=never . " .. drive
    fzf.fzf_exec(find_command , {
        prompt = "Change Directory> ",
        actions = {
            ["default"] = function(selected)
                -- selected[1] is the path string
                local path = selected[1]
                if path then
                    vim.cmd("cd " .. path)
                    print("CWD changed to: " .. vim.fn.getcwd())
                end
            end,
        },
    })
end

vim.keymap.set('n', '<leader>sf', ':FzfLua files<cr>')
vim.keymap.set('n', '<leader>sg', ':FzfLua live_grep<cr>')
vim.keymap.set('n', '<leader>c', FzfChangeDirectory)
vim.keymap.set('n', '<leader><leader>', ':FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>e', ':Oil<cr>')
vim.keymap.set('n', '<leader>g', 'Git<cr')
vim.keymap.set('n', '<leader>t', ToggleTerminal)
vim.keymap.set('n', '<leader>f', Format)
vim.keymap.set('v', '<leader>f', Format)

vim.cmd.colorscheme 'quiet'
vim.opt.background = 'dark'
