local Util = require("skkeleton_pointer.util")
local Config = require("skkeleton_pointer.config")

---@class State
---@field win? integer
---@field opts PointerWinOpts
local State = {
  prev = nil,
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
  vim.api.nvim_set_hl(0, "SkkeletonPointerState", {
    fg = "#2e3440",
    bg = "#acbe8c",
    bold = true,
  })
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

  self.prev = Util.get_state()
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
    local current_state = Util.get_state()
    if self.prev == "henkan" and current_state == "input:okurinasi" then
      vim.api.nvim_win_set_config(self.win, {
        relative = "cursor",
        row = 1,
        col = -vim.fn.strdisplaywidth(label),
        width = vim.fn.strdisplaywidth(label),
      })
    else
      vim.api.nvim_win_set_config(self.win, {
        width = vim.fn.strdisplaywidth(label),
      })
    end
    self.prev = Util.get_state()
  else
    self:open()
  end
end

---@return nil
function State:close()
  vim.schedule(function()
    if self:visible() then
      local buf = vim.api.nvim_win_get_buf(self.win)
      vim.api.nvim_win_close(self.win, true)
      vim.api.nvim_buf_clear_namespace(buf, Config.namespace, 0, -1)
      vim.api.nvim_buf_delete(buf, { force = true })
      self.win = nil
    end
  end)
end

---@param text string
---@return nil
function State:set_text(text)
  local buf = vim.api.nvim_win_get_buf(self.win)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
  vim.api.nvim_buf_clear_namespace(buf, Config.namespace, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, Config.namespace, "SkkeletonPointerState", 0, 0, -1)
end

return State
