CharacterManager = inherit(Singleton)

function CharacterManager:constructor()
    self.m_PossessedHook = Hook:New()
    self.m_UnPossessedHook = Hook:New()

    NanosCharacter:Subscribe("Spawn", bind(self.Event_Spawn, self))
    NanosCharacter:Subscribe("Respawn", bind(self.Event_Respawn, self))
    NanosCharacter:Subscribe("Possessed", bind(self.Event_Possessed, self))
    NanosCharacter:Subscribe("UnPossessed", bind(self.Event_UnPossessed, self))
	NanosCharacter:Subscribe("Destroy", bind(self.Event_Spawn, self))

    NanosCharacter:Subscribe("Death", bind(self.Event_Death, self))
    NanosCharacter:Subscribe("TakeDamage", bind(self.Event_TakeDamage, self))
    NanosCharacter:Subscribe("PickUp", bind(self.Event_PickUp, self))
	NanosCharacter:Subscribe("ViewModeChanged", bind(self.Event_ViewModeChanged, self))

    for _, character in pairs(NanosCharacter) do
        if character:IsValid() then
			enew(character, Character)

			local player = character:GetPlayer()
			if player then
				character:SpawnNametag(player:GetName())
			end
        end
    end
end

function CharacterManager:destructor()
end

function CharacterManager:GetPossessedHook()
	return self.m_PossessedHook
end

function CharacterManager:GetUnPossessedHook()
	return self.m_UnPossessedHook
end

function CharacterManager:Event_ViewModeChanged(character, oldState, newState)
    -- 0 - FPS, 1 - TPS1, 2 - TPS2, 3 - TPS3
	--[[
	if character:GetPlayer() then
		local player = character:GetPlayer()

		if player == Player.LocalPlayer then
			local lockedViewMode = Player.LocalPlayer:GetLockedViewMode()
			if lockedViewMode == "FPV" then
				if newState ~= 0 then
					character:SetViewMode(0)
					return false
				end
			elseif lockedViewMode == "TPV" then
				if newState == 0 then
					character:SetViewMode(oldState ~= 0 and oldState or 1)
				end
			end
		end
	end
	]]
end

function CharacterManager:Respawn(player, character)
    character:Delete()
    player:Respawn()
    return false
end

function CharacterManager:Event_TakeDamage(character, damage, type, bone, fromDirection, instigator)
    -- character:OnTakeDamage(damage, type, bone, fromDirection, instigator)
end

function CharacterManager:Event_Spawn(character)

end

function CharacterManager:Event_Respawn(character)
end

function CharacterManager:Event_Possessed(character, player)
    self.m_PossessedHook:Call(player, character)
    character:SpawnNametag(player:GetName())
end

function CharacterManager:Event_UnPossessed(character, player)
    self.m_UnPossessedHook:Call(player, character)
    character:DestroyNametag()
end

function CharacterManager:Event_PickUp(character, object)
end

function CharacterManager:Event_Death(character)
end
