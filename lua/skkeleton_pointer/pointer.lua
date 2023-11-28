local Config = require("skkeleton_pointer.config")
local Autocmd = require("skkeleton_pointer.autocmd")
local Mode = require("skkeleton_pointer.mode")
local State = require("skkeleton_pointer.state")

---@class Pointer
local Pointer = {}

---@return Pointer
function Pointer.new()
  return setmetatable({}, { __index = Pointer })
end

function Pointer:setup()
  local autocmd = Autocmd.new()

  local mode = Mode.new(Config.opts.mode_win_opts or {})
  autocmd:add({
    {
      "InsertEnter",
      "*",
      function()
        mode:open()
      end,
    },
    {
      "InsertLeave",
      "*",
      function()
        mode:close()
      end,
    },
    {
      "CursorMovedI",
      "*",
      function()
        mode:move()
      end,
    },
    {
      "User",
      "skkeleton-mode-changed",
      function()
        mode:update()
      end,
    },
  })

  if Config.opts.use_state_pointer then
    local state = State.new(Config.opts.state_win_opts or {})
    autocmd:add({
      {
        "User",
        "skkeleton-handled",
        function()
          state:update()
        end,
      },
    })
  end
end

return Pointer
