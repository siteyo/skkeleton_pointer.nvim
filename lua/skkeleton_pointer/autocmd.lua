---@class Autocmd
---@field group integer
local Autocmd = {}

---@return Autocmd
function Autocmd.new()
  return setmetatable({
    group = vim.api.nvim_create_augroup("skkeleton-pointer", {}),
  }, { __index = Autocmd })
end

---@param commands table
---@return nil
function Autocmd:add(commands)
  for _, command in ipairs(commands) do
    vim.api.nvim_create_autocmd(command[1], {
      group = self.group,
      pattern = command[2],
      callback = command[3],
    })
  end
end

return Autocmd
