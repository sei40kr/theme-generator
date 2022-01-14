local out_name = vim.g.generator_out_name

local function get_hex_color_string(rgb)
	return ("%06x"):format(rgb)
end

local terminal_colors = {}

local function init_terminal_colors()
	terminal_colors = {}

	for i = 0, 15 do
		local name = string.format("terminal_color_%d", i)
		terminal_colors[i] = vim.g[name]
	end
end

local hl_defaults = {
	TelescopeMatching = "Special",
	TelescopeMultiIcon = "Identifier",
	TelescopeNormal = "Normal",
	TelescopePreviewBorder = "TelescopeNormal",
	TelescopePreviewNormal = "Normal",
	TelescopePromptPrefix = "Identifier",
	TelescopeSelection = "Visual",
	TelescopeSelectionCaret = "TelescopeSelection",
}
local hl_defs = {}

local function init_hl_defs(names)
	hl_defs = {}

	for _, name in ipairs(names) do
		local success, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
		local t = name
		while not success and hl_defaults[t] ~= nil do
			t = hl_defaults[t]
			success, hl = pcall(vim.api.nvim_get_hl_by_name, t, true)
		end
		if hl == nil then
			hl = {}
		end

		hl_defs[name] = {
			fg = hl.foreground and get_hex_color_string(hl.foreground),
			bg = hl.background and get_hex_color_string(hl.background),
			underline = hl.underline or false,
			undercurl = hl.undercurl or false,
			strikethrough = hl.strikethrough or false,
			reverse = hl.reverse or false,
			italic = hl.italic or false,
		}
	end
end

local function gen_tmux_theme()
	local function get_tmux_style(hl)
		local attrs = {}

		if hl.fg ~= nil then
			table.insert(attrs, "fg=#" .. hl.fg)
		end
		if hl.bg ~= nil then
			table.insert(attrs, "bg=#" .. hl.bg)
		end
		for _, name in ipairs({ "bold", "italic", "reverse", "strikethrough" }) do
			if hl[name] then
				table.insert(attrs, name)
			end
		end
		if hl.underline then
			table.insert(attrs, "underscore")
		end
		if hl.undercurl then
			table.insert(attrs, "curly-underscore")
		end

		return table.concat(attrs, ",")
	end

	vim.fn.writefile({
		"tmux set-option -g copy-mode-current-match-style '" .. get_tmux_style(hl_defs.Search) .. "'",
		"tmux set-option -g copy-mode-match-style '" .. get_tmux_style(hl_defs.Search) .. "'",
		"tmux set-option -g message-command-style '" .. get_tmux_style(hl_defs.StatusLine) .. "'",
		"tmux set-option -g message-style '" .. get_tmux_style(hl_defs.StatusLine) .. "'",
		"tmux set-option -g mode-style '" .. get_tmux_style(hl_defs.Visual) .. "'",
		"tmux set-option -g pane-active-border-style '" .. get_tmux_style(hl_defs.VertSplit) .. "'",
		"tmux set-option -g pane-border-style '" .. get_tmux_style(hl_defs.VertSplit) .. "'",
		"tmux set-option -g status-style '" .. get_tmux_style(hl_defs.TabLineFill) .. "'",
		"tmux set-option -g window-status-current-style '" .. get_tmux_style(hl_defs.TabLineSel) .. "'",
		"tmux set-option -g window-status-style '" .. get_tmux_style(hl_defs.TabLine) .. "'",
	}, "tmux_" .. out_name .. ".tmux")
	vim.fn.setfperm("tmux_" .. out_name .. ".tmux", "rwxr--r--")
end

init_hl_defs({
	"Search",
	"StatusLine",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
	"TelescopeMatching",
	"TelescopeMultiIcon",
	"TelescopeNormal",
	"TelescopePreviewBorder",
	"TelescopePreviewNormal",
	"TelescopePromptPrefix",
	"TelescopeSelection",
	"TelescopeSelectionCaret",
	"VertSplit",
	"Visual",
})
init_terminal_colors()

gen_tmux_theme()
