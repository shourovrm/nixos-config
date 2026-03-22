-- Explicitly loaded plugins; lazy.nvim also auto-discovers all sibling .lua files.
return {
  require("rms.plugins.treesitter"),
  require("rms.plugins.comment"),
}
