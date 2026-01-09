local M = {}


function M.run_current_file()
  local ft = vim.bo.filetype

  if ft == "go" then
    vim.cmd("w")
    vim.cmd( "go run %")
  elseif ft == "rust" then
    vim.cmd("w")
    vim.cmd("cargo run")
  elseif ft == "python" then
    vim.cmd("w")
    vim.cmd("python3 %")
  end
end

return M
