return {
  "Mirsmog/real-icons.nvim",
  build = ":RealIconsInstallPack material",
  opts = {
    pack = "material",
    integrations = {
      telescope = true,
      nvim_tree = true,
      mini_files = true,
      snacks_picker = true,
      lualine = true,
    },
  },
}
