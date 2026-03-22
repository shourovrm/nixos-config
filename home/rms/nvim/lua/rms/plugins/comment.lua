return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup({
            toggler = {
                line  = "gcc",   -- Toggle comment on current line
                block = "gbc",   -- Toggle block comment
            },
            opleader = {
                line  = "gc",    -- Operator for line comments
                block = "gb",    -- Operator for block comments
            },
        })
    end,
}
