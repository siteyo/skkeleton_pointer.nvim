local Util = require("skkeleton_pointer.util")

---@class State
---@field win? integer
---@field opts PointerWinOpts
local State = {
  win = nil,
  opts = {},
}

---@param opts PointerWinOpts
---@return State
function State.new(opts)
  local self = setmetatable({}, { __index = State })
  return self:init(opts)
end

---@param opts PointerWinOpts
---@return State
function State:init(opts)
  self.opts = opts
  -- TODO: Sets a highlight group.
  return self
end

---@return boolean
function State:visible()
  return self.win ~= nil and vim.api.nvim_win_is_valid(self.win)
end

---@return nil
function State:open()
  local label = Util.get_state_label()
  if label == "" then
    return
  end

  ---@type integer
  local buf = vim.api.nvim_create_buf(false, true)

  ---@type PointerWinOpts
  local opts = vim.tbl_deep_extend("force", {
    relative = "cursor",
    row = 1,
    col = -vim.fn.strdisplaywidth(label),
    height = 1,
    width = vim.fn.strdisplaywidth(label),
    style = "minimal",
    focusable = false,
  }, self.opts)
  self.win = vim.api.nvim_open_win(buf, false, opts)

  self:set_text(label)
end

---@return nil
function State:update()
  if self:visible() then
    local label = Util.get_state_label()
    if label == "" then
      self:close()
      return
    end
    self:set_text(label)
    vim.api.nvim_win_set_config(self.win, {
      width = vim.fn.strdisplaywidth(label),
    })
  else
    self:open()
  end
end

function State:close()
  vim.schedule(function()
    local buf = vim.api.nvim_win_get_buf(self.win)
    vim.api.nvim_win_close(self.win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    self.win = nil
  end)
end

---@param text string
function State:set_text(text)
  local buf = vim.api.nvim_win_get_buf(self.win)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, { text })
end

return State
