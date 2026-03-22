return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                c      = { "clang_format" },
                cpp    = { "clang_format" },
                cuda   = { "clang_format" },
                python = { "black" },
            },
        })

        vim.keymap.set("n", "<leader>ff", function()
            require("conform").format({ lsp_fallback = true })
        end, { desc = "Format file" })
    end,
}
