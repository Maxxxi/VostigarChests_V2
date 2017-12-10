	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier
	local Lang = Library.Translate
	-- Table for already visited points --
	local waypointVisited = {}

	local InitTime = Inspect.Time.Real()
	local InitCounter = 0
	-- Second to update coord --
	local newTimer = 0.5

	-- Reset waypoint visited --
	function resetWaypointTable()
		for key, x in ipairs(waypointVisited) do
			table.remove(waypointVisited, key)
		end
	end

	-- Exports the table of coordinate points visited --
	local function allreadyVisited(cX, cZ)
		visited = false
		for k, v in pairs(waypointVisited) do
			if v[1] == cX and v[2] == cZ then
				visited = true
			end
		end
	end

	function alertMessage()
		if Inspect.System.Watchdog() < 0.1 then return end
		if Inspect.Time.Real() - InitTime > 5 then
			InitTime = Inspect.Time.Real()
			VostigarChestsAlert:SetVisible(false)
		end
	end

	-- Poster function of the distance between the player and the chests --
	local function updateDistances(frame, frameStatus, pX, pY, cX, cZ)
		-- Distance calculation --
		local distance = math.sqrt( ((pX - cX) ^2) + ((pY - cZ) ^2) )

		-- Rounded number of the distance --
		distance = math.ceil(distance) -1

		-- Set Text to frame --
		frame:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. distance .. Lang.SPACE .. Lang.METERS)

		-- Check the coordinates already visited --
		allreadyVisited(cX, cZ)

		-- look for if there is already a point of marked --
		local allreadyPointed = Inspect.Map.Waypoint.Get("player")

		-- If the location has not been visited yet, the point is displayed on the map and the table of visited points is updated. --
		if visited == false then
			-- Add a color according to the distance --
			if distance <= 150 then
				-- Add or clear waypoint --
				if allreadyPointed == nil and distance <= 500  then
					-- Add waypoint --
					Command.Map.Waypoint.Set(cX, cZ)
					VostigarChestsAlert:SetText(Lang.CHESTSFINDED)
					alertMessage()
				elseif allreadyPointed == nil and distance > 500 then
					-- Erase waypoint --
					Command.Map.Waypoint.Clear()
				elseif (allreadyPointed == nil or allreadyPointed == cX) and distance <= 10 then
					-- Erase waypoint --
					Command.Map.Waypoint.Clear()
					-- Add the visited coordinates in a table --
					upWay = {cX, cZ}
					table.insert(waypointVisited, upWay)
					frameStatus:SetTexture("Rift", "raid_icon_notready.png.dds")
					VostigarChestsAlert:SetVisible(false)
				end
				frame:SetFontColor(0, 1, 0)
			elseif distance > 150 and distance <= 700 then
				frame:SetFontColor(1, 1, 0)		
			else
				frame:SetFontColor(255, 0, 0)
			end
		end
	end
	 
	-- Update the player's coordinates --
	local function updateChestsCoord()
		coordZ = 0
		coordX = 0
		for k, v in pairs(coordData) do
			if v[4] then
				updateDistances(v[4], v[5], Inspect.Unit.Detail("player").coordX, Inspect.Unit.Detail("player").coordZ, v[2], v[3])
			end
		end
	end

	-- Update Coord every x second --
	local function newUpdate(h, currentZoneName)
		if LIBZONECHANGE.currentZoneName == Lang.VOSTIGARPIC then
			if Inspect.System.Watchdog() < 0.1 then return end
			if Inspect.Time.Real() - InitTime >= newTimer then 
				InitTime = Inspect.Time.Real()
				InitCounter = InitCounter + 1
				updateChestsCoord()
			end

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

		else
			-- Reset Event left Clic on Button --
			function VostigarChestsButton.Event:LeftClick()
				VostigarChestsAlert:SetText("Vous n\'etes pas dans la bonne zone pour afficher la fenêtre.")
				alertMessage()
			end	

			-- Event OnMouseIn button --
			function VostigarChestsButton.Event:MouseIn()
				if not VostigarChestsWindow.visible then
					-- Apply texture --
					self:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
				end
			end

			-- Event OnMouseOut button --
			function VostigarChestsButton.Event:MouseOut()
				if not VostigarChestsWindow.visible then
					-- Apply texture --
					self:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
				end
			end

			-- If the window is open we close it --
			if VostigarChestsWindow:GetVisible() then
				VostigarChestsWindow:SetVisible(false)
				-- Re assign button image --
				VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
				-- Switch on / off button --
				VostigarChestsWindow.visible = not VostigarChestsWindow.visible
			end
		end
	end

	-- Alert message --
	Command.Event.Attach(Event.System.Update.Begin, alertMessage, "Alert Message function")
	
	-- Update coordinates every X seconds when the player moves --
	Command.Event.Attach(Event.Unit.Detail.Coord, newUpdate, AddonId .. "Active newUpdate")

	-- Check the zone in which we are thanks to the library --
	Command.Event.Attach(Library.libZoneChange.Player, newUpdate, "Library.LibZoneChange.Player")