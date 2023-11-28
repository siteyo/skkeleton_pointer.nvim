local Pointer = require("skkeleton_pointer.pointer")

local pointer = Pointer.new()

---@class SkkeletonPointer
---@field instance Pointer
local M = {
  instance = pointer,
}

---@param opts SkkeletonPointerOpts
function M.setup(opts)
  require("skkeleton_pointer.config"):setup(opts)
  pointer:setup()
end

return M
