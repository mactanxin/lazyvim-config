return {
  "Kurama622/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
  config = function()
    local tools = require("llm.common.tools")
    require("llm").setup({
      -- [[ openrouter]]
      url = "https://openrouter.ai/api/v1/chat/completions",
      -- model = "google/gemini-2.0-flash-exp:free",
      model = "anthropic/claude-sonnet-4",
      max_tokens = 8000,
      api_type = "openai",
      fetch_key = function()
        return vim.env.OPENROUTER_KEY
      end,
      Completion = {
        opts = {
          keymap = {
            virtual_text = {
              accept = {
                mode = "i",
                keys = "<A-a>",
              },
              next = {
                mode = "i",
                keys = "<A-n>",
              },
              prev = {
                mode = "i",
                keys = "<A-p>",
              },
            },
            toggle = {
              mode = "n",
              keys = "<leader>cp",
            },
          },
        },
        -- Enable LLM completion
        enabled = true,
        -- Show LLM completion in the completion menu
        show_in_completion_menu = true,
        -- Show LLM completion in the command line
        show_in_command_line = true,
        style = "blink.cmp",
      },
    })
  end,
  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
  },
}
