TeamDeathmatch = inherit(BaseMode)
TeamDeathmatch.Name = "team_deathmatch"

function TeamDeathmatch:virtual_constructor()
    self.m_Name = TeamDeathmatch.Name

	self.m_PublicData["timeLimit"] = 15 * 60
	self.m_PublicData["scoreLimit"] = 60
	self.m_PublicData["scoreTeam1"] = 0
	self.m_PublicData["scoreTeam2"] = 0
	self.m_PublicData["nameTeam1"] = "Red"
	self.m_PublicData["nameTeam2"] = "Blue"

    self.m_TimeStart = os.time()
	self.m_Ending = false

    self.m_SpawnMinDistance = 250

    self.m_Respawn = bind(self.Respawn, self)

    self.m_Spawns = MapManager:GetSingleton():GetCurrentMap():GetSpawnLocations(self.m_Name)
    self.m_ViewModes = MapManager:GetSingleton():GetCurrentMap():GetViewModes()
    self.m_Timer = Timer:SetTimeout(500, bind(self.Tick, self), {})
end

function TeamDeathmatch:virtual_destructor()
    Timer:ClearTimeout(self.m_Timer)
    for k, player in ipairs(self.m_Players) do
        if player:IsValid() then
            local character = player:GetControlledCharacter()
            if character and character:IsValid() then
                local weapon = character:GetCurrentPickUpObject()
                if weapon and weapon:IsValid() then
                    weapon:Destroy()
                end
                character:Destroy()
            end
        end
    end
end

function TeamDeathmatch:EndRound()
	BaseMode.EndRound(self)
	if self.m_Ending then
        return
	end

    self.m_Ending = true
    for k, player in ipairs(self.m_Players) do
        if player:GetControlledCharacter() then
            self:OnPlayerDeath(player:GetControlledCharacter(), player, nil)
            player:GetControlledCharacter():Destroy()
        end

        Events:CallRemote("GameMode_RoundEnd", player, {})
    end

    Timer:SetTimeout(10 * 1000, function()
        GamemodeManager:GetSingleton():NextGame()
        return false
    end, {})
end

function TeamDeathmatch:CanStart()
    Package:Log("Deathmatch:CanStart " .. tostring(self:GetState()) .. " " .. tostring(#self.m_Players))
    if self:GetState() == BaseMode.States.PreRound then
        if #self.m_Players >= 2 then
            return true
        end
    end

    return false
end

function TeamDeathmatch:GetWeapon()
	local random = math.floor(math.random() * 6)
	if random == 0 then
		return NanosWorldWeapons.AK47(Vector(), Rotator())
	elseif random == 1 then
		return NanosWorldWeapons.AK74U(Vector(), Rotator())
	elseif random == 2 then
		return NanosWorldWeapons.GE36(Vector(), Rotator())
	elseif random == 3 then
		return NanosWorldWeapons.AR4(Vector(), Rotator())
	elseif random == 4 then
		return NanosWorldWeapons.AP5(Vector(), Rotator())
	elseif random == 5 then
		return NanosWorldWeapons.SMG11(Vector(), Rotator())
	else
		return NanosWorldWeapons.SMG11(Vector(), Rotator())
	end
end

function TeamDeathmatch:Tick()
    if self:GetState() ~= BaseMode.States.Running then return end
    self.m_TimeElapsed = os.time() - self.m_TimeStart

    if self.m_TimeElapsed >= self:GetTimeLimit() then
        self:EndRound()
    end
end

function TeamDeathmatch:AddPlayer(player)
	local teams = self:GetPlayersPerTeam()
	local nextTeam = #teams[1] < #teams[2] and 1 or 2

    Package:Log("AddPlayer " .. tostring(player))
    table.insert(self.m_Players, player)
    player:SetPublicData("Score", 0)
    player:SetPublicData("Kills", 0)
	player:SetPublicData("Deaths", 0)
	player:SetPublicData("Team", nextTeam)

    Events:CallRemote("GameMode_RoundStart", player, {})

    player:SetLockedViewMode("FPV")

    self:Spawn(player)
end

function TeamDeathmatch:GetPlayersPerTeam()
	local teams = {
		[1] = {},
		[2] = {}
	}

	for _, player in pairs(self.m_Players) do
		if player:IsValid() then
			table.insert(teams[player:GetPublicData("Team")], player)
		end
	end

	return teams
end

function TeamDeathmatch:RemovePlayer(player)
    Package:Log("RemovePlayer " .. tostring(player))
    table.removevalue(self.m_Players, player)
    local character = player:GetControlledCharacter()
    Package:Log("RemovePlayer " .. tostring(character))
    
    if character and character:IsValid() then
        local weapon = character:GetCurrentPickUpObject()
        Package:Log("RemovePlayer " .. tostring(weapon))
        if weapon and weapon:IsValid() then
            weapon:Destroy()
        end
        character:Destroy()
    end
end

function TeamDeathmatch:Spawn(player)
    if self.m_Ending then
        return
    end
    Package:Log("Spawn " .. tostring(player))
    local position = self:GetSpawnPosition(player)
	local character = NanosCharacter(position, Rotator(), "NanosWorld::SK_Male")
	character:SetSpeedMultiplier(1.1)
	character:AddSkeletalMeshAttached("shirt", "NanosWorld::SK_Shirt")
	character:AddSkeletalMeshAttached("pants", "NanosWorld::SK_Pants")
	character:AddSkeletalMeshAttached("shoes", "NanosWorld::SK_Shoes_01")
	character:AddStaticMeshAttached("hair", "NanosWorld::SM_Hair_Short", "hair_male")


    local weapon = self:GetWeapon()
    player:Possess(character)
	character:PickUp(weapon)
	character:SetTeam(player:GetPublicData("Team"))
	character:SetMaterialColorParameter("ShirtTint", player:GetPublicData("Team") == 1 and Color(0.4, 0, 0, 1) or Color(0, 0, 0.4, 1))
	character:SetMaterialColorParameter("PantsTint", player:GetPublicData("Team") == 1 and Color(0.4, 0, 0, 1) or Color(0, 0, 0.4, 1))
end

function TeamDeathmatch:Respawn(player, character)
    if self.m_Ending then
        return
    end
    if character and character:IsValid() then
        local position = self:GetSpawnPosition(player)
        character:SetHealth(100)
        character:SetLocation(position)
        local weapon = self:GetWeapon()
        character:PickUp(weapon)
    else
        self:Spawn(player)
    end
    return false
end

function TeamDeathmatch:GetSpawnPosition(player)
    local position
    local minDistance = -1
    local team = player:GetPublicData("Team")

    for i = 1, 10 do
        position = self.m_Spawns[math.random(1, #self.m_Spawns)]

        for k, player2 in ipairs(self.m_Players) do
            local character = player2:GetControlledCharacter()
            if character and character:GetHealth() > 0 and player2:GetPublicData("Team") ~= team then
                local distance = position:Distance(character:GetLocation())
                if distance < minDistance or minDistance == -1 then
                    minDistance = distance
                end
            end
        end

        if minDistance == -1 or minDistance > self.m_SpawnMinDistance then
            Package:Log("Found spawnpoint after " .. tostring(i) .. " tries")
            break
        end
    end
    Package:Log("Got spawnpoint")
    
    return position
end

function TeamDeathmatch:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
    if table.find(self.m_Players, player) then
        local weapon = character:GetCurrentPickUpObject()
        if weapon and weapon:IsValid() then
            weapon:Destroy()
        end

		player:IncreasePublicData("Deaths")

		if player:GetPublicData("Team") == 1 then
			self:SetPublicData("scoreTeam2", self:GetPublicData("scoreTeam2") + 1)
		else
			self:SetPublicData("scoreTeam1", self:GetPublicData("scoreTeam1") + 1)
		end


        if instigator and player ~= instigator then
            instigator:IncreasePublicData("Kills")
			instigator:IncreasePublicData("Score")

			local instigatorCharacter = instigator:GetControlledCharacter()

			if character and character:IsValid() then
				local weaponInstigator = instigatorCharacter:GetCurrentPickUpObject()

				if weaponInstigator and weaponInstigator:IsValid() then
					self:SendKillFeedEntry(string.format("%s killed %s with %s", instigator:GetName(), player:GetName(), weaponInstigator:GetName()))
				else
					self:SendKillFeedEntry(string.format("%s killed %s", instigator:GetName(), player:GetName()))
				end
			else
                self:SendKillFeedEntry(string.format("%s killed %s", instigator:GetName(), player:GetName()))
			end
        else
            self:SendKillFeedEntry(string.format("%s died", player:GetName()))
        end

		if self:GetPublicData("scoreTeam1") >= self:GetScoreLimit() or self:GetPublicData("scoreTeam2") >= self:GetScoreLimit() then
			self:EndRound()
		end

        if not self.m_Ending then
            Timer:SetTimeout(2000, self.m_Respawn, {player, character})
        end
    end
end
