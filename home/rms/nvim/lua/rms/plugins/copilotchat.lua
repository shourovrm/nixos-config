-- Note: `build = "make tiktoken"` is removed; it requires Rust toolchain to
-- compile a native extension and is not needed for basic operation.
return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master" },
    },
    config = function()
        local chat = require("CopilotChat")

        chat.setup({
            window = {
                layout = "vertical",
                width  = 0.3,
                height = 1.0,
            },
            show_help = true,
            model     = "claude-haiku-4.5",
        })

        vim.keymap.set({ "n", "v" }, "<leader>cc", function() chat.toggle() end,
            { desc = "Toggle Copilot Chat" })
        vim.keymap.set({ "n", "v" }, "<leader>cr", function() chat.reset() end,
            { desc = "Reset Copilot Chat" })
        vim.keymap.set({ "n", "v" }, "<leader>ce", function()
            chat.ask("Explain this code in detail",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Explain Code" })
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
            chat.ask("Fix this code and explain what was wrong",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Fix Code" })
        vim.keymap.set({ "n", "v" }, "<leader>co", function()
            chat.ask("Optimize this code for better performance",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Optimize Code" })
        vim.keymap.set({ "n", "v" }, "<leader>ct", function()
            chat.ask("Write comprehensive tests for this code",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Write Tests" })
        vim.keymap.set({ "n", "v" }, "<leader>cd", function()
            chat.ask("Write documentation for this code",
                { selection = require("CopilotChat.select").visual })
        end, { desc = "Copilot Write Docs" })
    end,
}
