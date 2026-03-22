return {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled     = true,
                auto_trigger = true,
                keymap = {
                    accept  = "<C-l>",
                    next    = "<C-j>",
                    prev    = "<C-k>",
                    dismiss = "<C-h>",
                },
            },
            panel = { enabled = false },
        })
    end,
}
