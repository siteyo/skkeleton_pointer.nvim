local Util = require("skkeleton_pointer.util")
local Config = require("skkeleton_pointer.config")

---@class Mode
---@field win? integer
---@field opts PointerWinOpts
local Mode = {
  timer = vim.loop.new_timer(),
  win = nil,
  opts = {},
}

---@param opts PointerWinOpts
---@return Mode
function Mode.new(opts)
  local self = setmetatable({}, { __index = Mode })
  return self:init(opts)
end

---@param opts PointerWinOpts
---@return Mode
function Mode:init(opts)
  self.opts = opts
  vim.api.nvim_set_hl(0, "SkkeletonPointerMode", {
    fg = "#2e3440",
    bg = "#88c0d0",
    bold = true,
  })
  return self
end

---@return boolean
function Mode:visible()
  return self.win ~= nil and vim.api.nvim_win_is_valid(self.win)
end

---@return nil
function Mode:open()
  local label = Util.get_mode_label()

  if label == "" then
    return
  end

  ---@type integer
  local buf = vim.api.nvim_create_buf(false, true)

  ---@type PointerWinOpts
  local opts = vim.tbl_deep_extend("force", {
    relative = "cursor",
    row = 1,
    col = 0,
    height = 1,
    width = vim.fn.strdisplaywidth(label),
    style = "minimal",
    focusable = false,
  }, self.opts)
  self.win = vim.api.nvim_open_win(buf, false, opts)

  self:set_text(label)
end

---@return nil
function Mode:update()
  if self:visible() then
    local label = Util.get_mode_label()

    if label == "" then
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

---@type nil
function Mode:move()
  if self:visible() then
    ---@type PointerWinOpts
    local opts = vim.tbl_deep_extend("force", {
      relative = "cursor",
      row = 1,
      col = 0,
    }, self.opts)
    vim.api.nvim_win_set_config(self.win, opts)
  end
end

---@type nil
function Mode:close()
  vim.schedule(function()
    if self:visible() then
      local buf = vim.api.nvim_win_get_buf(self.win)
      vim.api.nvim_win_close(self.win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
      self.win = nil
    end
  end)
end

---@param text string
---@return nil
function Mode:set_text(text)
  local buf = vim.api.nvim_win_get_buf(self.win)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
  vim.api.nvim_buf_add_highlight(buf, Config.namespace, "SkkeletonPointerMode", 0, 0, -1)
  if Config.opts.fade_out_ms > 0 then
    self.timer:start(Config.opts.fade_out_ms, 0, function()
      self:close()
    end)
  end
end

return Mode
