-- Suppress lspconfig deprecation warning (harmless)
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
    if name and name:match("lspconfig") then
        return
    end
    return original_deprecate(name, alternative, version, plugin, backtrace)
end

require("rms.set")
require("rms.remap")
require("rms.lazy")
