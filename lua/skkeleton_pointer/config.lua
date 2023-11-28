---@class SkkeletonPointerOpts
---@field mode ModeLabels
---@field state StateLabels
---@field use_state_pointer boolean
---@field mode_win_opts PointerWinOpts
---@field state_win_opts PointerWinOpts

---@class ModeLabels
---@field hira string
---@field kata string
---@field hankata string
---@field zenkaku string
---@field abbrev string
---@field latin string

---@class StateLabels
---@field input string
---@field input_okurinasi string
---@field input_okuriari string
---@field henkan string
---@field escape string

---@class PointerWinOpts
---@field row? integer
---@field col? integer
---@field zindex? integer

---@class SkkeletonPointerConfig
---@field opts SkkeletonPointerOpts
---@field namespace integer
local Config = {}

---@param opts SkkeletonPointerOpts
function Config:setup(opts)
  self.opts = vim.tbl_deep_extend("force", {
    mode = {
      hira = "あ",
      kata = "ア",
      hankata = "ｶﾅ",
      zenkaku = "Ａ",
      abbrev = "abbrev",
      latin = "_A",
    },
    state = {
      input = "",
      input_okurinasi = "▽▽",
      input_okuriari = "▽*",
      henkan = "▼▼",
      escape = "",
    },
    mode_win_opts = {},
    state_win_opts = {},
    use_state_pointer = true,
  }, opts or {})
end

Config.namespace = vim.api.nvim_create_namespace("skkeleton_pointer")

return Config
