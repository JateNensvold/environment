local M = {}
function M.is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
end

function M.get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

function M.get_project_or_cwd()
    local cwd = vim.fn.getcwd()
    if M.is_git_repo() then
        cwd = M.get_git_root()
    end
    return cwd
end

function M.default(value, default_value)
    if value == nil then
        return default_value
    else
        return value
    end
end

function M.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. M.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

--- Formats a string using a table of substitutions
--- E.g. `M.format("Hello ${subject}", { subject = "world" })` returns 'Hello World'
---
--- @param str string The string to format
--- @param tbl table k-v pairs of string substitutions
--- @return string, number
function M.format(str, tbl)
    return str:gsub("$%b{}", function(param)
        return (tbl[string.sub(param, 3, -2)] or param)
    end)
end

return M
