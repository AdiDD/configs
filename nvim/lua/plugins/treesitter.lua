return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				-- core
				"lua",
				"vim",

				-- stack
				"javascript",
				"typescript",
				"tsx",
				"python",
				"go",
				"gomod",
				"gosum",
				"gowork",

				-- common formats
				"json",
				"yaml",
				"toml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"dockerfile",
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		-- This should be false according to docs. Disable it if notice conflicts with other maps.
		-- init = function()
		--   vim.g.no_plugin_maps = true
		-- end,

		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			-- Select textobjects
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "TS: around function" })

			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "TS: inner function" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "TS: around class" })

			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "TS: inner class" })

			-- Move between functions
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "TS: next function start" })

			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "TS: prev function start" })

			-- Swap parameters
			vim.keymap.set("n", "<leader>sp", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "TS: swap param with next" })

			vim.keymap.set("n", "<leader>sP", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "TS: swap param with prev" })

			-- Repeat last TS move
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
			vim.keymap.set(
				{ "n", "x", "o" },
				";",
				ts_repeat_move.repeat_last_move_next,
				{ desc = "TS: repeat move next" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				",",
				ts_repeat_move.repeat_last_move_previous,
				{ desc = "TS: repeat move prev" }
			)
		end,
	},
}
