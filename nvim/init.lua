-- ===== Basics =====
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- ===== Indentation =====
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Remove treesitter folds by default
vim.o.foldlevelstart = 99

-- ===== UI =====
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.titlestring = "nvim/%{fnamemodify(getcwd(), ':t')}"

-- ===== Behavior =====
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 300

-- Leader key
vim.g.mapleader = " "

-- Clear search highlight
vim.keymap.set("n", "<leader>/", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Ignore .gitignore for :grep
vim.o.grepprg = "rg --vimgrep"

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window navigation from terminal
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- Exit terminal insert
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])


-- Window resize (countable)
local function vresize(delta)
  local n = vim.v.count1 -- defaults to 1 if no count given
  local amount = math.abs(delta) * n
  local sign = (delta >= 0) and "+" or "-"
  vim.cmd(("vertical resize %s%d"):format(sign, amount))
end

local function hresize(delta)
  local n = vim.v.count1
  local amount = math.abs(delta) * n
  local sign = (delta >= 0) and "+" or "-"
  vim.cmd(("resize %s%d"):format(sign, amount))
end

vim.keymap.set("n", "<leader>wh", function() vresize(-2) end, { desc = "Window narrower" })
vim.keymap.set("n", "<leader>wl", function() vresize( 2) end, { desc = "Window wider" })
vim.keymap.set("n", "<leader>wj", function() hresize( 2) end, { desc = "Window taller" })
vim.keymap.set("n", "<leader>wk", function() hresize(-2) end, { desc = "Window shorter" })
vim.keymap.set("n", "<leader>we", "<cmd>wincmd =<cr>", { desc = "Equalize window sizes" })

-- Tab navigation
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>tab split<cr>", { desc = "Current file in new tab" })

-- Buffers
vim.keymap.set("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Switch to other Buffer" })

-- Dele current buffer without closing the window
vim.keymap.set("n", "<leader>bd", function()
    local buf = vim.api.nvim_get_current_buf()
    if #vim.api.nvim_tabpage_list_wins(0) == 1 then
        vim.cmd("enew")
    else
        vim.cmd("bnext")
    end
    vim.api.nvim_buf_delete(buf, { force = false })
end, { desc = "Delete buffer (keep tab)" })

-- Delete all other buffers
vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()
    local visible = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        visible[buf] = true
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current
            and vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buflisted
            and not visible[buf]
        then
            -- don't delete modified buffers
            if not vim.bo[buf].modified then
                pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
        end
    end
end, { desc = "Delete other (non-visible) buffers" })

-- LAZY VIM
require("config.lazy")

-- TREESITTER
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        -- enable TS highlighting if parser exists
        pcall(vim.treesitter.start, args.buf)

        -- folds (optional)
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})

-- LSP FORMATTING
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and (client.name == "eslint" or client.name == "ts_ls") then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- Navigation
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "gi", vim.lsp.buf.implementation, "Implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Type definition")

        -- Hover / signature
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Code actions
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

        -- Diagnostics
        map("n", "[d", function()
            vim.diagnostic.jump({ count = -1 })
        end, "Previous diagnostic")

        map("n", "]d", function()
            vim.diagnostic.jump({ count = 1 })
        end, "Next diagnostic")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics to loclist")
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 250,
        })
    end,
})
