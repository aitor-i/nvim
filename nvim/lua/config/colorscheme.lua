local available_colorschemes = {
	"tokyonight",
	"lunar",
	"catppuccin",
	"kanagawa",
	"nightfox",
	"gruvbox",
	"everforest",
	"aether",
}

local function apply_colorscheme(name)
	local target = name and name ~= "" and name or vim.g.colorscheme
	if not target or target == "" then
		target = vim.g.omarchy_colorscheme or "everforest"
	end

	local ok = pcall(vim.cmd.colorscheme, target)
	if not ok then
		vim.notify("Colorscheme '" .. target .. "' not found", vim.log.levels.WARN)
		return
	end

	vim.g.colorscheme = target
end

vim.api.nvim_create_user_command("ColorScheme", function(opts)
	apply_colorscheme(opts.args)
end, {
	nargs = "?",
	complete = function()
		return available_colorschemes
	end,
})

apply_colorscheme(vim.g.colorscheme)
