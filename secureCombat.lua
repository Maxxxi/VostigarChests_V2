	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier

	-- Hide the window and the button in combat --
	function Event_System_Secure_Enter()
		-- cache la fenetre --
		if VostigarChestsWindow:GetVisible() then
			VostigarChestsWindow:SetVisible(false)
			-- réattribu l'image du bouton --
			VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
		end
		-- cache le bouton --
		VostigarChestsButton:SetVisible(false)
	end

	-- Displays the button and the window (if it was open) when coming out of combat --
	function Event_System_Secure_Leave()
		if VostigarChestsWindow.visible then
			VostigarChestsWindow:SetVisible(true)
			-- réattribu l'image du bouton --
			VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonUp.png" )
		else
			VostigarChestsWindow:SetVisible(false)
			-- réattribu l'image du bouton --
			VostigarChestsButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
		end	
		-- Affiche le bouton --
		VostigarChestsButton:SetVisible(true)	
	end

	-- Enter combat --
	Command.Event.Attach(Event.System.Secure.Enter, Event_System_Secure_Enter, "Event.System.Secure.Enter")
	-- Leave combat --
	Command.Event.Attach(Event.System.Secure.Leave, Event_System_Secure_Leave, "Event.System.Secure.Leave")