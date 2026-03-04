local M = require "utils.functions"
local lazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazyPath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazyPath,
    })
end
vim.opt.rtp:prepend(lazyPath)

-- List of plugins that should be enabled when running in VSCode
local enabled_plugins = {
    "comment.lua",
    "nvim-autopair.lua",
    "plenary.lua",
    "vim-surround.lua",
    "osc52.lua",
    "guess-indent.lua",
    -- "eyeliner.lua",
    -- "nvim-colorizer.lua",
    -- Enable search results highlights
    -- "nvim-scrollbar.lua"
    -- vscode does not support spawning new buffers
    -- "nvim-tree.lua",
    -- vscode automatically highlights the word under cursor
    -- "illuminate.lua"
}

-- Convert enabled plugins list to a set for faster lookup
local function create_enabled_set(plugins)
    local set = {}
    for _, plugin in ipairs(plugins) do
        set[plugin] = true
    end
    return set
end

-- Filter plugin specs based on enabled plugins list when in VSCode
local function get_plugin_spec()
    if vim.g.vscode then
        vim.notify("VSCode enabled", vim.log.levels.WARN)
        local enabled_set = create_enabled_set(enabled_plugins)
        local filtered_specs = {}

        -- Get all plugin files in the lazy directory
        local lazy_path = vim.fn.stdpath("config") .. "/lua/tosh-vim/lazy"
        local plugin_files = vim.fn.glob(lazy_path .. "/*.lua", true, true)

        for _, file_path in ipairs(plugin_files) do
            local filename = vim.fn.fnamemodify(file_path, ":t")

            if enabled_set[filename] then
                local module_name = "tosh-vim.lazy." .. vim.fn.fnamemodify(filename, ":r")
                local success, plugin_spec = pcall(require, module_name)

                if success then
                    table.insert(filtered_specs, plugin_spec)
                else
                    vim.notify("Failed to load plugin: " .. filename, vim.log.levels.WARN)
                end
                vim.notify(M.dump(filtered_specs))
            end
        end

        return {
            spec = filtered_specs,
            change_detection = { notify = false },
            rocks = { enabled = false },
        }
    else
        vim.notify("VSCode not enabled", vim.log.levels.WARN)
        return {
            spec = "tosh-vim.lazy",
            change_detection = { notify = false },
            rocks = { enabled = false },
        }
    end
end

require("lazy").setup(get_plugin_spec())
