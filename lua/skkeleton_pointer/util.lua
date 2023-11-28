local Config = require("skkeleton_pointer.config")
---@class Util
local Util = {}

---@return string
function Util.get_mode_label()
  local mode = vim.api.nvim_get_var("skkeleton#mode")
  return Config.opts.mode[mode == "" and "latin" or mode]
end

---@return string
function Util.get_state_label()
  local state = vim.api.nvim_get_var("skkeleton#state")
  return Config.opts.state[string.gsub(state.phase, ":", "_")] or ""
end

return Util
