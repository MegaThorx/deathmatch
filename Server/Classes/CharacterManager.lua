CharacterManager = inherit(Singleton)

function CharacterManager:constructor()
    NanosCharacter:Subscribe("Spawn", bind(self.Event_Spawn, self))
    NanosCharacter:Subscribe("Respawn", bind(self.Event_Respawn, self))
    NanosCharacter:Subscribe("Possessed", bind(self.Event_Possessed, self))
    NanosCharacter:Subscribe("Death", bind(self.Event_Death, self))
    NanosCharacter:Subscribe("TakeDamage", bind(self.Event_TakeDamage, self))
    NanosCharacter:Subscribe("PickUp", bind(self.Event_PickUp, self))
    NanosCharacter:Subscribe("ViewModeChanged", bind(self.Event_ViewModeChanged, self))

    self.m_Respawn = bind(self.Respawn, self)
end

function CharacterManager:destructor()
    for _, character in pairs(NanosCharacter) do
        character:Delete()
    end
end

function CharacterManager:Event_ViewModeChanged(character, oldState, newState)
	-- 0 - FPS, 1 - TPS1, 2 - TPS2, 3 - TPS3

	if true then return end

    if character:GetPlayer() then
        local player = character:GetPlayer()
        local viewMode = player:GetLockedViewMode()
        local lockedViewMode = player:GetLockedViewMode()
        if lockedViewMode == "FPV" then
			if newState ~= 0 then
				if oldState ~= 0 then
					character:SetViewMode(0)
				end
				return true
            end
        elseif lockedViewMode == "TPV" then
            if newState == 0 then
                character:SetViewMode(oldState ~= 0 and oldState or 1)
				return true
            end
        end
	end
end

function CharacterManager:Respawn(player, character)
    character:Delete()
    player:Respawn()
    return false
end

function CharacterManager:Event_TakeDamage(character, damage, type, bone, fromDirection, instigator)
    Package:Log(inspect({
        character = character,
        damage = damage,
        type = type,
        bone = bone,
        fromDirection = fromDirection,
        instigator = instigator
    }))
    local player = character:GetPlayer()
    
	if player ~= nil and instigator and instigator ~= player and character:IsAlive() then
		Events:CallRemote("HUD_AddScoreFeedEntry", instigator, {"Enemy hit", damage, true})
		instigator:SetPublicData("Score", instigator:GetPublicData("Score") + damage)
	end
    -- character:OnTakeDamage(damage, type, bone, fromDirection, instigator)
end

function CharacterManager:Event_Spawn(character)
    -- Give random weapon?
    -- character:PickUp(NanosWorldWeapons.AK47(Vector(), Rotator()))
end

function CharacterManager:Event_Respawn(character)
    -- Give random weapon?
    -- character:PickUp(NanosWorldWeapons.AK47(Vector(), Rotator()))
end

function CharacterManager:Event_Possessed(character, player)
    player:UpdateViewMode()
end

function CharacterManager:Event_PickUp(character, object)
    character:OnPickUp(object)
end

function CharacterManager:Event_Death(character, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection, instigator)
    local player = character:GetPlayer()

	if player ~= nil and instigator and instigator ~= player then
		local headshot = lastBoneDamaged == "head" or lastBoneDamaged == "neck_01"
		local points = 25
		Events:CallRemote("HUD_AddScoreFeedKill", instigator, {player:GetName(), 25, headshot})
		if headshot then
			points = points + 25
			Events:CallRemote("HUD_AddScoreFeedEntry", instigator, {"Headshot", 25, false})
		end
		instigator:SetPublicData("Score", instigator:GetPublicData("Score") + points)
	end

    character:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    PlayerManager:GetSingleton():OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
end
