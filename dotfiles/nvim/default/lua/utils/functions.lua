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

return M
