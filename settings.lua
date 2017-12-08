	--[[
		Vostigar Chests ADDON
		Thank's Wicendawen for update
		Ranadyla@Brisesol
	]]--

	local toc, btb = ...
	local AddonId = toc.identifier

	-- Define VostigarChestsSettings table --
	if VostigarChestsSettings == nil then 
		VostigarChestsSettings = {} 
	end

	-- Define VostigarChestsSettings table --
	if VostigarChestsSettings.window == nil then
		VostigarChestsSettings = {}
		VostigarChestsSettings.window = {
			x = math.floor(UIParent:GetWidth() / 3),
			y = math.floor(UIParent:GetHeight() / 3)
		}
	end