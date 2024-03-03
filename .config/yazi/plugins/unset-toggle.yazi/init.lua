return {
	entry = function()
		local tab = cx.active.mode
		local cmd = nil
		local args = nil
		if tab.is_select and tab.is_visual then
			ya.manager_emit("escape", { visual = "" })
		end
		if tab.is_unset then
			cmd = "escape"
			args = { visual = "" }
		else
			cmd = "visual_mode"
			args = { unset = "" }
		end
		ya.manager_emit(cmd, args)
	end,
}
