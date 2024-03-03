return {
	entry = function()
		ya.err("---------------------------------------------")
		-- ya.err(tostring(ya.active.current.hovered))
		local hovered = cx.active.current.hovered
		for k, v in pairs(hovered) do
			ya.err(tostring(k) .. " " .. tostring(v))
		end
		-- local file = cx.active.current
		-- local file_abs_name = tostring(file.cwd) .. "/" .. file.hovered.name
		-- ya.err("cwd " .. tostring(file.cwd) .. "   " .. tostring(file.hovered.name))
		-- ya.err("$EDITOR " .. file_abs_name)
		-- ya.manager_emit("shell", { block = "", confirm = "", "$EDITOR " .. file_abs_name })
	end,
}
