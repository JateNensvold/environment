local M = require "utils.functions"
return {
	"davidmh/cspell.nvim",
	-- "JateNensvold/cspell.nvim",
	-- branch = "multi-config",
	-- dev = false,
	-- dir = "~/projects/cspell.nvim/",
	enabled = true,
	config = function()
		local Job = require('plenary.job')
		local cspell_config = {
			diagnostics_postprocess = function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity["HINT"] -- ERROR, WARN, INFO, HINT
			end,
			disabled_filetypes = { "netrw", "NvimTree" },
			config = {
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
					return encoded_json
				end
			}
		}
		local cspell = require('cspell')
		require("null-ls").register({
			cspell.diagnostics.with(cspell_config),
			cspell.code_actions.with(cspell_config),
		})
	end
}
