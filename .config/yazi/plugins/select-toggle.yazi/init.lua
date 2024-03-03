return {
	entry = function()
		local tab = cx.active.mode
		local cmd = nil
		local args = {}
		if tab.is_unset then
			ya.manager_emit("escape", { visual = "" })
		end
		if tab.is_select and tab.is_visual then
			cmd = "escape"
			args = { visual = "" }
		else
			cmd = "visual_mode"
		end
		ya.manager_emit(cmd, args)
	end,
}
--[[

		local cmd = nil
		ya.err("----------------------")
		ya.err(tostring(tab))
		ya.err(tostring(tab.is_select))
		ya.err(tostring(tab.is_visual))
		ya.err(tostring(tab.is_unset))
		if tab.is_select and tab.is_visual then
			cmd = "escape"
		else
			cmd = "visual_mode"
		end
		ya.err(cmd)
		ya.err("----------------------")

--]]
--
