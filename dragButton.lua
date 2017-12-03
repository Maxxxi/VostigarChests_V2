	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier

	local function dragDown(dragState, frame, event, ...)
		local mouse = Inspect.Mouse()
		dragState.dx = dragState.window:GetLeft() - mouse.x
		dragState.dy = dragState.window:GetTop() - mouse.y
		dragState.dragging = true
	end

	local function dragUp(dragState, frame, event, ...)
		dragState.dragging = false
	end

	local function dragMove(dragState, frame, event, x, y)
		if dragState.dragging then
			dragState.variable.x = x + dragState.dx
			dragState.variable.y = y + dragState.dy
			dragState.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", dragState.variable.x, dragState.variable.y)
		end
	end

	function dragAttach(window, variable)
		local 	dragState = { window = window, variable = variable, dragging = false }
				window:EventAttach(Event.UI.Input.Mouse.Right.Down, 		function(...) 	dragDown(dragState, ...) 	end, "dragDown")
				window:EventAttach(Event.UI.Input.Mouse.Right.Up, 			function(...) 	dragUp(dragState, ...) 		end, "dragUp")
				window:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, 	function(...) 	dragUp(dragState, ...) 		end, "dragUpoutside")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
	end