	--[[
		Vostigar Chests ADDON
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier
	local Lang = Library.Translate

	local cellName
	local cellCoord
	local Coord
	local VostigarChestsButton
	local VostigarChestsWindow 
	local VostigarChestsContext
	local VostigarChestsResetPoint

	local VostigarChestsList = {}

	local distance = {}
	local Coord = {} 
	local cellName = {} 
	local cellCoord = {} 

	-- Récupère les coordonnées du joueur --
	local player = Inspect.Unit.Detail("player")

	-- Cache la fenêtre et le bouton en combat --
	local function Event_System_Secure_Enter(h)
		VostigarChestsWindow:SetVisible(false)
		VostigarChestsButton:SetVisible(false)
	end

	-- Affiche le bouton et la fenêtre (si elle etait ouverte) en sortant de combat --
	local function Event_System_Secure_Leave(h)
		if VostigarChestsWindow.visible then
			VostigarChestsWindow:SetVisible(true)
		else
			VostigarChestsWindow:SetVisible(false)
		end	
		-- Affiche le bouton --
		VostigarChestsButton:SetVisible(true)
	end

	-- Coordonnées des coffres et non de la zone --
	local coordData = {
		{Lang.FORETOUBLIE, 	3086, 2849},
		{Lang.FORETOUBLIE, 	3090, 2844},
		{Lang.VOIXDESTRUC, 	3445, 2920},
		{Lang.VOIXDESTRUC, 	3585, 2910},
		{Lang.VOIXDESTRUC, 	3840, 2827},
		{Lang.VOIXDESTRUC, 	3926, 2966},
		{Lang.THEFRONT, 	3810, 2255},
		{Lang.THEFRONT, 	4055, 2300},
	}

	-- Define VostigarChestsSettings table --
	if VostigarChestsSettings == nil then 
		VostigarChestsSettings = {} 
	end

	-- Define VostigarChestsSettings table --
	if VostigarChestsSettings.window == nil then
		VostigarChestsSettings.window = {
			x = math.floor(UIParent:GetWidth() / 3),
			y = math.floor(UIParent:GetHeight() / 3)
		}
	end

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

	local function dragAttach(window, variable)
		local 	dragState = { window = window, variable = variable, dragging = false }
				window:EventAttach(Event.UI.Input.Mouse.Right.Down, 		function(...) 	dragDown(dragState, ...) 	end, "dragDown")
				window:EventAttach(Event.UI.Input.Mouse.Right.Up, 			function(...) 	dragUp(dragState, ...) 		end, "dragUp")
				window:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, 	function(...) 	dragUp(dragState, ...) 		end, "dragUpoutside")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
	end

	-- Met à jour les coordonnées du joueur --
	local function updateChestsCoord()
		-- Défini 0 s'il n'y a pas de coordonnée pour le joueur --
		if player.coordX == nil then
			player.coordX = 0
		else
			player.coordX = player.coordX
		end
		-- Défini 0 s'il n'y a pas de coordonnée pour le joueur --
		if player.coordY == nil then
			player.coordY = 0
		else
			player.coordY = player.coordY
		end
	end

	-- Vostigar Chests Frame --
	local function VostigarChests()
		-- Create Context --
		VostigarChestsContext = UI.CreateContext("VostigarChestsContext")
		VostigarChestsContext:SetSecureMode("restricted")

		-- Create Main Frame --
		VostigarChestsWindow = UI.CreateFrame("SimpleWindow", "VostigarChestsWindow", VostigarChestsContext)
		VostigarChestsWindow:SetSecureMode("restricted")
		VostigarChestsWindow:SetVisible(false)
		VostigarChestsWindow:SetTitle(Lang.BTBVOSTIGARCHEST)
		VostigarChestsWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 60, 60)
		VostigarChestsWindow:SetCloseButtonVisible(false)
		VostigarChestsWindow:SetWidth(550)
		VostigarChestsWindow:SetHeight(350)

		-- Create Scrolling Frame --
		VostigarChestsScrollView = UI.CreateFrame("SimpleScrollView", VostigarChestsWindow:GetName().."_ScrollView", VostigarChestsWindow)
		VostigarChestsScrollView:SetSecureMode("restricted")
		VostigarChestsScrollView:SetPoint("TOPLEFT", VostigarChestsWindow, "TOPLEFT", 30, 70)
		VostigarChestsScrollView:SetWidth(VostigarChestsWindow:GetWidth() - 60)
		VostigarChestsScrollView:SetHeight(VostigarChestsWindow:GetHeight() - 120)

		-- Create Grid Frame --
		VostigarChestsGrid = UI.CreateFrame("SimpleGrid", VostigarChestsWindow:GetName().."_Grid", VostigarChestsScrollView)
		VostigarChestsGrid:SetSecureMode("restricted")
		VostigarChestsGrid:SetPoint("TOPLEFT", VostigarChestsScrollView, "TOPLEFT")
		VostigarChestsGrid:SetBackgroundColor(0, 0, 0, 0.5)
		VostigarChestsGrid:SetWidth(VostigarChestsWindow:GetWidth())
		VostigarChestsGrid:SetHeight(VostigarChestsWindow:GetHeight())
		VostigarChestsGrid:SetMargin(1)
		VostigarChestsGrid:SetCellPadding(1)

		-- Create Reset Button  --
		VostigarChestsResetPoint = UI.CreateFrame("RiftButton", VostigarChestsWindow:GetName().."_ResetPoint", VostigarChestsWindow)
		VostigarChestsResetPoint:SetText(Lang.RESETPOI)
		VostigarChestsResetPoint:SetPoint("BOTTOMCENTER", VostigarChestsWindow, "BOTTOMCENTER", 0, -15)

		-- Create Show Button --
		VostigarChestsButton = UI.CreateFrame("Texture", VostigarChestsWindow:GetName().."_Button", VostigarChestsContext)
		VostigarChestsButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", VostigarChestsSettings.window.x, VostigarChestsSettings.window.y)
		VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
		VostigarChestsButton:ClearWidth()
		VostigarChestsButton:SetWidth(30)
		VostigarChestsButton:SetHeight(30)
		VostigarChestsButton:SetVisible(true)

		-- Create Close button --
		VostigarChestsButtonClose = UI.CreateFrame("RiftButton", VostigarChestsWindow:GetName().."_ButtonClose", VostigarChestsWindow)
		VostigarChestsButtonClose:SetSkin("close")
		VostigarChestsButtonClose:SetPoint("TOPRIGHT", VostigarChestsWindow, "TOPRIGHT", -8, 16)
	end

	-- Mouse Function's --
	local function VostigarChestsFunctions()
		-- Event left Clic on Button --
		function VostigarChestsButton.Event:LeftClick()
			if not VostigarChestsWindow.visible then
				VostigarChestsWindow:SetVisible(true)
			else
				VostigarChestsWindow:SetVisible(false)
			end	
			-- Apply texture --
			self:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
			-- on / off button --
			VostigarChestsWindow.visible = not VostigarChestsWindow.visible
		end

		-- Event on mouse out button --
		function VostigarChestsButton.Event:MouseIn()
			if not VostigarChestsWindow.visible then
				-- Apply texture --
				self:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
			end
		end

		-- Event on mouse out button --
		function VostigarChestsButton.Event:MouseOut()
			if not VostigarChestsWindow.visible then
				-- Apply texture --
				self:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
			end
		end

		-- Event on close window --
		function VostigarChestsButtonClose.Event:LeftPress()
			if VostigarChestsWindow.visible then
				VostigarChestsButton:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
				VostigarChestsWindow:SetVisible(false)
			end	
			-- on / off button --
			VostigarChestsWindow.visible = not VostigarChestsWindow.visible
		end

		-- Event on reset waypoint --
		function VostigarChestsResetPoint.Event:LeftPress()
			-- Restricted Mode --
			VostigarChestsContext:SetSecureMode("restricted")
			VostigarChestsWindow:SetSecureMode("restricted")
			self:SetSecureMode("restricted")
			-- Launch cmd --
			self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "/clearwaypoint")
		end

		-- Move VostigarChestsButton --
		dragAttach(VostigarChestsButton, VostigarChestsSettings.window)
	end

	local function VostigarChestsGetData()
		-- Write Name and Coord --
		for k, v in pairs(coordData) do
			-- Coordonnées en mètres --
			local distance = math.sqrt( (player.coordX - v[2]) ^2 + (player.coordY - v[3]) ^2 )
			newDistance = math.ceil(distance)

			-- Zone Name --
			local cellName = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_CellName", VostigarChestsGrid)
			cellName:SetText(tostring(v[1]))
			cellName:SetFontSize(14)

			-- Zone Coord --
			local cellCoord = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_CellCoord", VostigarChestsGrid)
			cellCoord:SetFontSize(14)
			cellCoord:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. tostring(v[2]) .. ", " .. tostring(v[3]))


			-- Zone Distance --
			local cellDistance = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_cellDistance", VostigarChestsGrid)
			cellDistance:SetFontSize(14)
			cellDistance:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. newDistance .. Lang.SPACE .. Lang.METERS)

			-- Ajoute une couleur selon la distance --
			if distance < 500 then
				-- Ajoute une couleur --
				cellDistance:SetFontColor(0, 1, 0)
			elseif distance >= 500 and distance <= 2000 then
				-- Ajoute une couleur --
				cellDistance:SetFontColor(1, 1, 0)
			else
				-- Ajoute une couleur --
				cellDistance:SetFontColor(255, 0, 0)
			end

			-- Event on Left Clic --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
				self:SetSecureMode("restricted")
				-- Launch cmd --
				self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "/setwaypoint " .. tostring(v[2]) .. ", " .. tostring(v[3]))
			end, "Event.UI.Input.Mouse.Left.Click")

			-- Event Mouse in --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
				-- Apply color --
				self:SetFontColor(0, 255, 0)
			end, "Event.UI.Input.Mouse.Cursor.In")

			-- Event Mouse Out --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
				-- Apply color --
				self:SetFontColor(1, 1, 1)
			end, "Event.UI.Input.Mouse.Cursor.Out")

			-- Create table --
			v.row = {cellName, cellCoord, cellDistance}
			-- Add to Grid --
			VostigarChestsGrid:AddRow(v.row)
		end

		-- Include Text in scroll --
		VostigarChestsScrollView:SetContent(VostigarChestsGrid)
	end

	-- Init Settings --
	local function settingsInitVostigarChests()
		if VostigarChestsSettings == nil then VostigarChestsSettings = {} end
			if VostigarChestsSettings.window == nil then
				VostigarChestsSettings.window = {
					x = math.floor(UIParent:GetWidth() / 4),
					y = math.floor(UIParent:GetHeight() / 4)
				}
		end
	end

	-- Enter combat --
	Command.Event.Attach(Event.System.Secure.Enter, Event_System_Secure_Enter, "Event.System.Secure.Enter")
	-- Leave combat --
	Command.Event.Attach(Event.System.Secure.Leave, Event_System_Secure_Leave, "Event.System.Secure.Leave")
	-- Update updateChestsCoord --
	Command.Event.Attach(Event.Unit.Detail.Coord, updateChestsCoord,"Locator update on unit coord change for chests")

	-- Init Addon --
	local function InitVostigarChests(handle, addonIdentifier)
		-- Error if loading bad addon --
		if addonIdentifier ~= AddonId then
			return
		end
		-- Load Addon --
		VostigarChests()
		-- Update Player Coord --
		updateChestsCoord()
		-- Load mouse function --
		VostigarChestsFunctions()
		-- Load Data Function --
		VostigarChestsGetData()
		-- Load Settings --
		settingsInitVostigarChests()
		-- Load Message --
		print(Lang.SPACE .. Lang.ADDONSTART)
	end

	-- Load Addon at the end of loading game --
	Command.Event.Attach(Event.Addon.Load.End, InitVostigarChests, AddonId .. " initialized")