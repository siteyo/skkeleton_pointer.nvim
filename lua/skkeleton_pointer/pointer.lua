local Config = require("skkeleton_pointer.config")
local Autocmd = require("skkeleton_pointer.autocmd")
local Mode = require("skkeleton_pointer.mode")
local State = require("skkeleton_pointer.state")

---@class Pointer
---@field mode Mode
---@field state State
local Pointer = {}

---@return Pointer
function Pointer.new()
  return setmetatable({}, { __index = Pointer })
end

---@return nil
function Pointer:setup()
  local autocmd = Autocmd.new()

  self.mode = Mode.new(Config.opts.mode_win_opts or {})
  autocmd:add({
    -- stylua: ignore start
    { "InsertEnter", "*", function() self.mode:open() end },
    { "InsertLeave", "*", function() self.mode:close() end },
    { "CursorMovedI", "*", function() self.mode:move() end },
    { "User", "skkeleton-mode-changed", function() self.mode:update() end },
    { "OptionSet", "background", function() self:refresh() end },
    -- stylua: ignore end
  })

  if Config.opts.use_state_pointer then
    self.state = State.new(Config.opts.state_win_opts or {})
    autocmd:add({
      -- stylua: ignore start
      { "User", "skkeleton-handled", function() self.state:update() end },
      { "OptionSet", "background", function() self:refresh() end },
      -- stylua: ignore end
    })
  end
end

function Pointer:refresh()
  self.mode = Mode.new(Config.opts.mode_win_opts or {})
  self.mode:update()
  if Config.opts.use_state_pointer then
    self.state = State.new(Config.opts.state_win_opts or {})
    self.state:update()
  end
end

return Pointer
