return {
    -- Git signs in the gutter + hunk actions
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 300,
                virt_text_pos = "eol",
            },
        },
        keys = {
            { "]h",          function() require("gitsigns").next_hunk() end,                 desc = "Next Hunk" },
            { "[h",          function() require("gitsigns").prev_hunk() end,                 desc = "Prev Hunk" },
            { "<leader>ghs", function() require("gitsigns").stage_hunk() end,                desc = "Stage Hunk" },
            { "<leader>ghr", function() require("gitsigns").reset_hunk() end,                desc = "Reset Hunk" },
            { "<leader>ghp", function() require("gitsigns").preview_hunk() end,              desc = "Preview Hunk" },
            { "<leader>ghb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line" },
        },
    },

    -- Diff UI + history
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        keys = {
            { "<leader>gdo", "<cmd>DiffviewOpen<cr>",          desc = "Diffview Open" },
            { "<leader>gdc", "<cmd>DiffviewClose<cr>",         desc = "Diffview Close" },
            { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
            { "<leader>gdF", "<cmd>DiffviewFileHistory<cr>",   desc = "Diffview Repo History" },
        },
    },
}
