-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- Define highlight transparente usando API Lua
local groups = {
  "Normal",
  "NormalNC",
  "VertSplit",
  "StatusLine",
  "LineNr",
  "Folded",
}

for _, group in ipairs(groups) do
  vim.api.nvim_set_hl(0, group, { bg = "none" })  -- remove fundo
end
vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi Folded guibg=NONE ctermbg=NONE
]])
-- Define highlight groups with transparent background after colorscheme is set
lvim.autocommands = {
  {
    "ColorScheme", -- triggered after colorscheme is loaded
    {
      pattern = "*",
      callback = function()
        -- UI Elements
        vim.api.nvim_set_hl(0, "Normal",           { bg = "NONE" }) -- main editor
        vim.api.nvim_set_hl(0, "NormalNC",         { bg = "NONE" }) -- unfocused window
        vim.api.nvim_set_hl(0, "EndOfBuffer",      { bg = "NONE" }) -- ~ lines
        vim.api.nvim_set_hl(0, "SignColumn",       { bg = "NONE" }) -- gutter signs
        vim.api.nvim_set_hl(0, "VertSplit",        { bg = "NONE" }) -- vertical split line
        vim.api.nvim_set_hl(0, "StatusLine",       { bg = "NONE" }) -- status bar
        vim.api.nvim_set_hl(0, "TabLine",          { bg = "NONE" }) -- tabline inactive
        vim.api.nvim_set_hl(0, "TabLineFill",      { bg = "NONE" }) -- tabline background
        vim.api.nvim_set_hl(0, "TabLineSel",       { bg = "NONE" }) -- tabline selected
        vim.api.nvim_set_hl(0, "Pmenu",            { bg = "NONE" }) -- popup menu
        vim.api.nvim_set_hl(0, "PmenuSel",         { bg = "NONE" }) -- popup menu selection
        vim.api.nvim_set_hl(0, "WinSeparator",     { bg = "NONE" }) -- window separator
        vim.api.nvim_set_hl(0, "FloatBorder",      { bg = "NONE" }) -- floating window border
        vim.api.nvim_set_hl(0, "MsgArea",          { bg = "NONE" }) -- command-line output
        vim.api.nvim_set_hl(0, "CursorLineNr",     { bg = "NONE" }) -- current line number
        vim.api.nvim_set_hl(0, "LineNr",           { bg = "NONE" }) -- line numbers

        -- NvimTree
        vim.api.nvim_set_hl(0, "NvimTreeNormal",       { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC",     { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer",  { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NvimTreeVertSplit",    { bg = "NONE" })
      end,
    },
  },
}

