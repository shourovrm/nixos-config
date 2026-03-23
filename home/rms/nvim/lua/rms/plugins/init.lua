-- lua/rms/plugins/init.lua
-- Explicitly load plugins that lazy.nvim would otherwise auto-discover out of
-- alphabetical order (e.g. treesitter must init before other parsers attach).
-- lazy.nvim still auto-discovers all other .lua files in this directory.
return {
  require("rms.plugins.treesitter"),
  require("rms.plugins.comment"),
}
