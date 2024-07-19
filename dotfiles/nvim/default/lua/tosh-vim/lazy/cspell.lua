local M = require "utils.functions"
return {
	"JateNensvold/cspell.nvim",
	-- "davidmh/cspell.nvim",
	branch = "multi-config",
	enabled = true,
	dev = false,
	dir = "~/projects/cspell.nvim/",
	config = function()
		local Job = require('plenary.job')
		local config = {
			cspell_config_dirs = {
				"~/.config/.cspell",
			},
			encode_json = function(cspell_tbl)
				local raw_json_string = vim.json.encode(cspell_tbl)
				local encoded_json = ""
				local job = Job:new({
					command = "jq",
					writer = raw_json_string,
					---@diagnostic disable-next-line: unused-local
					on_stdout = function(_, line)
						if encoded_json == "" then
							encoded_json = line
						else
							encoded_json = encoded_json .. '\n' .. line
						end
					end
				})
				local _, return_val = job:sync()

				if encoded_json == nil or encoded_json == "" or return_val ~= 0 then
					vim.notify(
						"Failed to encode lua table to json " .. M.dump(cspell_tbl),
						vim.log.levels.INFO,
						{ title = "cspell.nvim - Failed encode(" .. return_val .. ")" }
					)

					return raw_json_string
				end
				print(encoded_json)
				return encoded_json
			end
		}
		local cspell = require('cspell')
		local disabled_filetypes = { "netrw", "NvimTree" };
		require("null-ls").register({
			cspell.diagnostics.with({ config = config, disabled_filetypes = disabled_filetypes }),
			cspell.code_actions.with({ config = config, disabled_filetypes = disabled_filetypes }),
		})
	end
}
