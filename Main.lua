	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier
	local Lang = Library.Translate
	local screenHeight = UIParent:GetHeight() / 4
	local InitTime = Inspect.Time.Real()
	local InitCounter = 0
	-- Second to update coord --
	local newTimer = 0.5

	-- Chest coordinates and name of the zone --
	coordData = {
		{Lang.FORETOUBLIE, 	3072, 2845, nil, nil},
		{Lang.FORETOUBLIE, 	3090, 2844, nil, nil},
		{Lang.VOIXDESTRUC, 	3445, 2920, nil, nil},
		{Lang.VOIXDESTRUC, 	3585, 2910, nil, nil},
		{Lang.THEFRONT, 	3810, 2255, nil, nil},
		{Lang.VOIXDESTRUC, 	3821, 2827, nil, nil},
		{Lang.VOIXDESTRUC, 	3925, 2969, nil, nil},
		{Lang.THEFRONT, 	4033, 2584, nil, nil},
		{Lang.THEFRONT, 	4055, 2300, nil, nil},
		{Lang.VALONANKHET, 	4214, 2475, nil, nil},
	}

	-- Vostigar Chests Frame --
	local function VostigarChests()
		-- Create Context --
		VostigarChestsContext = UI.CreateContext("VostigarChestsContext")

		-- Create Main Frame --
		VostigarChestsWindow = UI.CreateFrame("SimpleWindow", "VostigarChestsWindow", VostigarChestsContext)
		VostigarChestsWindow:SetVisible(true)
		VostigarChestsWindow:SetTitle("\n" .. Lang.BTBVOSTIGARCHEST)
		VostigarChestsWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 60, 60)
		VostigarChestsWindow:SetCloseButtonVisible(true)
		VostigarChestsWindow:SetWidth(480)
		VostigarChestsWindow:SetHeight(300)

		-- CheckBox activation --
		VostigarChestsCheckBox = UI.CreateFrame("SimpleCheckbox", VostigarChestsWindow:GetName().."_CheckBox", VostigarChestsWindow)
		VostigarChestsCheckBox:SetPoint("BOTTOMRIGHT", VostigarChestsWindow, "BOTTOMRIGHT", -22, -18)
		VostigarChestsCheckBox:SetText(Lang.ACTIVEADDON)
		VostigarChestsCheckBox:SetLabelPos("left")
		VostigarChestsCheckBox:SetFontSize(12)
		VostigarChestsCheckBox:SetLayer(1)

		-- Create Reset Button  --
		VostigarChestsResetPoint = UI.CreateFrame("RiftButton", VostigarChestsWindow:GetName().."_ResetPoint", VostigarChestsWindow)
		VostigarChestsResetPoint:SetText(Lang.RESETPOI)
		VostigarChestsResetPoint:SetPoint("BOTTOMLEFT", VostigarChestsWindow, "BOTTOMCENTER", 0, -13)

		-- Create Reset Button  --
		VostigarChestsResetTable = UI.CreateFrame("RiftButton", VostigarChestsWindow:GetName().."_ResetTable", VostigarChestsWindow)
		VostigarChestsResetTable:SetText(Lang.RESETWAYPOINT)
		VostigarChestsResetTable:SetPoint("CENTERLEFT", VostigarChestsResetPoint, "CENTERLEFT", -VostigarChestsResetPoint:GetWidth() , 0)

		-- Create Show Button --
		VostigarChestsButton = UI.CreateFrame("Texture", VostigarChestsWindow:GetName().."_Button", VostigarChestsContext)
		VostigarChestsButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", VostigarChestsSettings.window.x, VostigarChestsSettings.window.y)
		VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
		VostigarChestsButton:ClearWidth()
		VostigarChestsButton:SetWidth(30)
		VostigarChestsButton:SetHeight(30)
		VostigarChestsButton:SetVisible(true)

		-- Create Alert Frame --
		VostigarChestsAlertFrame = UI.CreateFrame("Frame",  VostigarChestsWindow:GetName().."_AlertFrame", VostigarChestsContext)
		VostigarChestsAlertFrame:SetPoint("CENTER", UIParent, "CENTERTOP",0, screenHeight)
		-- Alert Text Frame --
		VostigarChestsAlert = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_VostigarChestsAlert", VostigarChestsAlertFrame)
		VostigarChestsAlert:SetPoint("CENTER", VostigarChestsAlertFrame, "CENTER", 0, 0)
		VostigarChestsAlert:SetFontSize(28)
		VostigarChestsAlert:SetFontColor(1, 1, 1)
		VostigarChestsAlert:SetEffectGlow({ strength = 3 })

		-- check if checked --
		if VostigarChestsSettings["Activate"] then
			VostigarChestsCheckBox:SetChecked(true)
		else
			VostigarChestsCheckBox:SetChecked(false)
		end
		-- Mise à jour quand on coche / décoche la case --
		VostigarChestsCheckBox.Event.CheckboxChange = function(self)
			if Inspect.Time.Real() - InitTime >= newTimer then 
				InitTime = Inspect.Time.Real()
				VostigarChestsAlert:SetText(Lang.RELOADUI)
				alertMessage()
			end
			VostigarChestsSettings["Activate"] = self:GetChecked()
		end

		-- Si la case est activé, on affiche les coord --
		if VostigarChestsSettings["Activate"] then
			-- Create Scrolling Frame --
			VostigarChestsScrollView = UI.CreateFrame("SimpleScrollView", VostigarChestsWindow:GetName().."_ScrollView", VostigarChestsWindow)
			VostigarChestsScrollView:SetPoint("TOPLEFT", VostigarChestsWindow, "TOPLEFT", 30, 70)
			VostigarChestsScrollView:SetWidth(VostigarChestsWindow:GetWidth() - 60)
			VostigarChestsScrollView:SetHeight(VostigarChestsWindow:GetHeight() - 120)
			-- Create Grid Frame --
			VostigarChestsGrid = UI.CreateFrame("SimpleGrid", VostigarChestsWindow:GetName().."_Grid", VostigarChestsScrollView)
			VostigarChestsGrid:SetPoint("TOPLEFT", VostigarChestsScrollView, "TOPLEFT")
			VostigarChestsGrid:SetBackgroundColor(0, 0, 0, 0.5)
			VostigarChestsGrid:SetWidth(VostigarChestsWindow:GetWidth())
			VostigarChestsGrid:SetHeight(VostigarChestsWindow:GetHeight())
			VostigarChestsGrid:SetMargin(1)
			VostigarChestsGrid:SetCellPadding(1)
		else
			VostigarChestsActivateText = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_VostigarChestsActivateText", VostigarChestsWindow)
			VostigarChestsActivateText:SetPoint("CENTER", VostigarChestsWindow, "CENTER", 0, 0)
			VostigarChestsActivateText:SetFontSize(16)
			VostigarChestsActivateText:SetEffectGlow({ strength = 3 })
			VostigarChestsActivateText:SetFontColor(255, 0, 0 )
			VostigarChestsActivateText:SetLayer(3)
			VostigarChestsActivateText:SetVisible(true)
			VostigarChestsActivateText:SetText(Lang.NOTACTIVE)
		end
	end

	-- Write Name and Coord --
	local function VostigarChestsGetData()
		for k, v in pairs(coordData) do
			-- Zone Name --
			local cellName = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_CellName", VostigarChestsGrid)
			cellName:SetText(tostring(v[1]))
			cellName:SetFontSize(14)
			cellName:SetFontColor(0, 255, 0)

			-- Zone Coord --
			local cellCoord = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_CellCoord", VostigarChestsGrid)
			cellCoord:SetFontSize(14)
			cellCoord:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. tostring(v[2]) .. ", " .. tostring(v[3]))

			-- Icone visited --
			local cellStatus = UI.CreateFrame("Texture", "cellstatus", VostigarChestsGrid)
			cellStatus:SetTexture("Rift", "btn_video_done.png.dds")
			btb.cellStatus = cellStatus

			-- Zone Distance --
			local cellDistance = UI.CreateFrame("Text", VostigarChestsWindow:GetName().."_cellDistance", VostigarChestsGrid)
			cellDistance:SetFontSize(14)
			cellDistance:SetWidth(VostigarChestsGrid:GetWidth() - (cellName:GetWidth() + cellCoord:GetWidth() + cellStatus:GetWidth()) )
			cellDistance:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.MOVETOUPDATE)

			-- Update cell distance --
			v[4] = cellDistance
			v[5] = cellStatus

			-- Event on Left Clic --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
				-- Add waypoint --
				Command.Map.Waypoint.Set(v[2], v[3])
			end, "Event.UI.Input.Mouse.Left.Click")

			-- Event on Left Clic --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
				-- Erase waypoint --
				Command.Map.Waypoint.Clear()
			end, "Event.UI.Input.Mouse.Right.Click")

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
			v.row = {cellName, cellCoord, cellStatus, cellDistance}
			-- Add to Grid --
			VostigarChestsGrid:AddRow(v.row)
		end
		-- Include Text in scroll --
		VostigarChestsScrollView:SetContent(VostigarChestsGrid)
	end

	-- Init Addon --
	local function InitVostigarChests(handle, addonIdentifier)
		-- Error if loading bad addon --
		if addonIdentifier ~= AddonId then
			return
		end
		-- Read the addon --
		VostigarChests()
		if VostigarChestsSettings["Activate"] then
			-- Read mouse functions --
			VostigarChestsFunctions()
			-- Reads the coordinate function --
			VostigarChestsGetData()
		else
			return
		end

		-- Write start addon Message --
		print(Lang.SPACE .. Lang.ADDONSTART)
	end
	
	-- Load Addon at the end of loading game --
	Command.Event.Attach(Event.Addon.Load.End, InitVostigarChests, AddonId .. " initialized")