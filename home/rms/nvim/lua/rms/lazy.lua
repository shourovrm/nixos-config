-- Bootstrap lazy.nvim into ~/.local/share/nvim/lazy/lazy.nvim (writable, outside Nix store)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("rms.plugins", {
  -- Keep lock file in the data dir so the read-only Nix-store config is untouched
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
