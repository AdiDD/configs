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
                autoread = false,
                autowrite = true,
            })
            -- Project name based on current working directory
            local function project_session_name()
                -- local cwd = vim.fn.getcwd()
                -- return vim.fn.fnamemodify(cwd, ":t") -- last path component

                local cwd = vim.fn.getcwd()
                local parts = vim.split(cwd, "[/\\]", { trimempty = true })

                local n = #parts
                if n == 0 then
                    return "root"
                elseif n == 1 then
                    return parts[1]
                else
                    return parts[n - 1] .. "__" .. parts[n]
                end
            end

            local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { desc = desc })
            end

            -- Read session for this project (only if it exists)
            map("<leader>Sr", function()
                local name = project_session_name()
                local ok = pcall(sessions.read, name)
                if not ok then
                    vim.notify(("No session found for '%s' (create with <leader>Sw)"):format(name), vim.log.levels.WARN)
                end
            end, "Session: read (project)")

            -- Write (create/update) session for this project
            map("<leader>Sw", function()
                sessions.write(project_session_name())
            end, "Session: write (project)")

            -- Delete project session
            map("<leader>Sd", function()
                local name = project_session_name()
                local ok = pcall(sessions.delete, name)
                if not ok then
                    vim.notify(("No session to delete for '%s'"):format(name), vim.log.levels.WARN)
                end
            end, "Session: delete (project)")

            map("<leader>SS", function() sessions.select() end, "Session: select")
            map("<leader>SW", function() sessions.select("write") end, "Session: select & write")
            map("<leader>SR", function() sessions.select("read") end, "Session: select & read")
            map("<leader>SD", function() sessions.select("delete") end, "Session: select & delete")
        end,
    },
}
