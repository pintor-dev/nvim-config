local servers = {
	"lua_ls",
        "jsonls",
        "pyright",
        "clangd",
        "jdtls",
        "bashls",
        "ts_ls",
        "awk_ls",
	-- "cssls",
	-- "html",
	-- "tsserver",
	-- "bashls",
	-- "yamlls",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    vim.notify("Error: lspconfig status is not ok.")
    return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	if vim.fn.has("nvim-0.11") == 1 and vim.lsp.config then
		pcall(function()
			local default_config = require("lspconfig.configs")[server]
			local final_opts = opts
			if default_config and default_config.default_config then
				final_opts = vim.tbl_deep_extend("force", default_config.default_config, opts)
			end
			vim.lsp.config(server, final_opts)
			vim.lsp.enable(server)
		end)
	else
		lspconfig[server].setup(opts)
	end
end

