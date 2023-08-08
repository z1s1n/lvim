-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--------------------------------------------------------------------------------
-- vim options
--------------------------------------------------------------------------------
local options = {
    smarttab = true,
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 1,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file
    hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "",                              -- allow the mouse to be used in neovim
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 0,                         -- always show tabs
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 100,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    tabstop = 4,                             -- insert 4 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    laststatus = 3,
    showcmd = false,
    ruler = true,
    relativenumber = false, -- set relative numbered lines
    numberwidth = 4,        -- set number column width to 2 {default 4}
    signcolumn = "yes",     -- always show the sign column, otherwise it would shift the text each time
    wrap = true,            -- display lines as one long line
    scrolloff = 0,
    sidescrolloff = 8,
    guifont = "monospace:h17", -- the font used in graphical neovim applications
    title = true,
    titleold = vim.split(os.getenv("SHELL") or "", "/")[3],
    -- colorcolumn = "80",
    -- colorcolumn = "120",
}
for k, v in pairs(options) do
    vim.opt[k] = v
end
--------------------------------------------------------------------------------
-- lvim
--------------------------------------------------------------------------------

lvim.colorscheme = "gruvbox"
lvim.format_on_save.enabled = true
lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.document_highlight = true

lvim.plugins = {
    { "ellisonleao/gruvbox.nvim" }
}

--------------------------------------------------------------------------------
-- nvim-tree
--------------------------------------------------------------------------------

local function open_nvim_tree(data)
    local IGNORED_FT = {
        "gitcommit",
    }

    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- &ft
    local filetype = vim.bo[data.buf].ft

    -- only files please
    if not real_file and not no_name then
        return
    end

    -- skip ignored filetypes
    if vim.tbl_contains(IGNORED_FT, filetype) then
        return
    end

    -- open the tree but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false })
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.api.nvim_create_autocmd({ "QuitPre" }, {
    callback = function() vim.cmd("NvimTreeClose") end,
})
--------------------------------------------------------------------------------
-- go
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end
})
--------------------------------------------------------------------------------
-- py
--------------------------------------------------------------------------------
require 'lspconfig'.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391', 'E741' },
                    maxLineLength = 200
                }
            }
        }
    }
}
--------------------------------------------------------------------------------
-- bash
--------------------------------------------------------------------------------
require 'lspconfig'.bashls.setup {}
