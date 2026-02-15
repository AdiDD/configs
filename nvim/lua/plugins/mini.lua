return {
    {
        "nvim-mini/mini.nvim",
        version = false,
        config = function()
            require("mini.comment").setup()
            require("mini.ai").setup()
            require("mini.align").setup()

            require("mini.move").setup({
                mappings = {
                    left = "<leader>mh",
                    right = "<leader>ml",
                    down = "<leader>mj",
                    up = "<leader>mk",
                    line_left = "<leader>mh",
                    line_right = "<leader>ml",
                    line_down = "<leader>mj",
                    line_up = "<leader>mk",
                },
            })

            require("mini.jump").setup()
            require("mini.jump2d").setup({ mappings = { start_jumping = "<leader>j" } })

            require("mini.operators").setup({
                exchange = { prefix = "gX" },
                replace = { prefix = "gR" },
            })

            local sessions = require("mini.sessions")
            sessions.setup({
                directory = vim.fn.stdpath("data") .. "/sessions",
                autoread = true,
                autowrite = true,
            })

            local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { desc = desc })
            end

            map("<leader>Sw", function() sessions.write() end, "Session: write")
            map("<leader>Sr", function() sessions.read() end, "Session: read")
            map("<leader>Sd", function() sessions.delete() end, "Session: delete")
            map("<leader>SS", function() sessions.select() end, "Session: select")
            map("<leader>SW", function() sessions.select("write") end, "Session: select & write")
            map("<leader>SR", function() sessions.select("read") end, "Session: select & read")
            map("<leader>SD", function() sessions.select("delete") end, "Session: select & delete")
        end,
    },
}
