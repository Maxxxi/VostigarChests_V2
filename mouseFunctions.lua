	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier
	local Lang = Library.Translate

	-- Mouse Function's --
	function VostigarChestsFunctions()
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

		-- Event on close window --
		function VostigarChestsButtonClose.Event:LeftPress()
			if VostigarChestsWindow.visible then
				VostigarChestsButton:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
				VostigarChestsWindow:SetVisible(false)
			end	

			-- on / off button --
			VostigarChestsWindow.visible = not VostigarChestsWindow.visible
		end

		-- Reset waypoint --
		function VostigarChestsResetPoint.Event:LeftPress()
			-- Add waypoint --
			Command.Map.Waypoint.Clear()
		end

		-- Reset waypoint --
		function VostigarChestsResetTable.Event:LeftPress()
			for k, v in ipairs(coordData) do
				if v[5] then
					v[5]:SetTexture("Rift", "btn_video_done.png.dds")
					-- Remove waypoint visited --
					resetWaypointTable()
				end
			end
		end

		-- Move VostigarChestsButton --
		dragAttach(VostigarChestsButton, VostigarChestsSettings.window)
	end
	
	Command.Event.Attach(Event.Addon.Load.End, VostigarChestsFunctions, AddonId .. " initialized")