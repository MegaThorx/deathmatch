SnowballFight = inherit(BaseMode)
SnowballFight.Name = "snowball_fight"

function SnowballFight:virtual_constructor()
	self.m_Name = SnowballFight.Name

	self.m_PublicData["timeLimit"] = 15 * 60
	self.m_PublicData["scoreLimit"] = 30

	self.m_TimeStart = os.time()
	self.m_Ending = false

	self.m_Respawn = bind(self.Respawn, self)
	self.m_OnSnowballHit = bind(self.OnSnowballHit, self)
	self.m_OnSnowballThrow = bind(self.OnSnowballThrow, self)
	self.m_RespawnSnowball = bind(self.RespawnSnowball, self)

	self.m_Spawns = MapManager:GetSingleton():GetCurrentMap():GetSpawnLocations(self.m_Name)
	self.m_ViewModes = MapManager:GetSingleton():GetCurrentMap():GetViewModes()
	self.m_Timer = Timer:SetTimeout(500, bind(self.Tick, self), {})
end

function SnowballFight:virtual_destructor()
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

function SnowballFight:EndRound()
	if self.m_Ending then
		return
	end

	self.m_Ending = true
	for k, player in ipairs(self.m_Players) do
		-- if player:GetControlledCharacter() then
			-- local character = player:GetControlledCharacter()
			-- player:UnPossess()
			-- local weapon = character:GetCurrentPickUpObject()
			-- if weapon and weapon:IsValid() then
			-- 	weapon:Destroy()
			-- end
			-- character:Destroy()
		-- end

		Events:CallRemote("GameMode_RoundEnd", player, {})
	end

	--[[
	Timer:SetTimeout(10 * 1000, function()
		GamemodeManager:GetSingleton():NextGame()
		return false
	end, {})
	]]
end

function SnowballFight:Tick()
	self.m_TimeElapsed = os.time() - self.m_TimeStart

	if self.m_TimeElapsed >= self:GetTimeLimit() then -- Disable time limit for now
		-- self:EndRound()
	end
end

function SnowballFight:AddPlayer(player)
	table.insert(self.m_Players, player)

	player:SetPublicData("Score", 0)
	player:SetPublicData("Kills", 0)
	player:SetPublicData("Deaths", 0)
	player:SetPublicData("Lives", 3)
	player:SetPublicData("LivesLastUpdate", os.time())

	Events:CallRemote("GameMode_RoundStart", player, {})

	player:SetLockedViewMode(nil)

	self:Spawn(player)
end

function SnowballFight:RemovePlayer(player)
	table.removevalue(self.m_Players, player)
end

function SnowballFight:Spawn(player)
	if self.m_Ending then
		return
	end

	local position = self.m_Spawns[math.random(1, #self.m_Spawns)]
	local character = NanosCharacter(position, Rotator(), "NanosWorld::SK_Mannequin")
    character:SetMaterialColorParameter("Tint", Color(1, 1, 1))
    character:SetCanDrop(false)
    character:SetSpeedMultiplier(1.25)
	character:AddStaticMeshAttached("head", "SnowMap::SM_Snowman_Head", "head", Vector(-10, 0, 0), Rotator(270, 0, 0))

	player:Possess(character)
	self:GiveSnowball(character)
end

function SnowballFight:Respawn(player, character)
	if self.m_Ending then
		return
	end
	player.m_Respawning = false
	if character and character:IsValid() then
		local position = self.m_Spawns[math.random(1, #self.m_Spawns)]
		character:SetHealth(100)
		character:SetLocation(position)
		self:GiveSnowball(character)
	else
		self:Spawn(player)
	end
	return false
end

function SnowballFight:CheckRemainingPlayers()
	local playersAlive = 0
	local remainingPlayer = nil
	for _, player in pairs(self.m_Players) do
		if player:IsValid() and player:GetPublicData("Lives") > 0 then
			remainingPlayer = player
			playersAlive = playersAlive + 1
		end
	end

	if playersAlive <= 1 then
		Server:BroadcastChatMessage(string.format("%s has won this round.", remainingPlayer:GetName()))
		self:EndRound()
	end
end

function SnowballFight:OnPlayerDeath(player, character, instigator, lastDamageTaken, lastBoneDamaged, damageTypeReason, hitFromDirection)
	if table.find(self.m_Players, player) then
		if player.m_Respawning then return end
		local weapon = character:GetCurrentPickUpObject()
		if weapon and weapon:IsValid() then
			weapon:Destroy()
		end

		player:IncreasePublicData("Deaths")
		player:DecreasePublicData("Lives")
		player:SetPublicData("LivesLastUpdate", os.time())

		--[[
		if killer then
			killer:IncreasePublicData("Kills")
			killer:IncreasePublicData("Score")
			self:SendKillFeedEntry(killer:GetName() .. " killed " .. player:GetName())
		else
			self:SendKillFeedEntry(player:GetName() .. " died")
		end
		]]

		self:CheckRemainingPlayers()

		if not self.m_Ending and player:GetPublicData("Lives") > 0 then
			player.m_Respawning = true
			Timer:SetTimeout(5000, self.m_Respawn, {player, character})
		else
			player:UnPossess()
			if character:IsValid() then
				character:Destroy()
			end
			player:SetCameraRotation(Rotator())
			Server:BroadcastChatMessage(string.format("%s has been eliminated.", player:GetName()))
		end
	end
end

function SnowballFight:GiveSnowball(character)
	if not character:IsValid() then return end
	local snowball = Grenade(Vector(0, 0, -10000), Rotator(), "SnowMap::SM_Snowball", "SnowMap::P_Snowball", "SnowMap::A_Snowball_Cue")

	--[[
	snowball.BaseDamage = 25
	snowball.MinimumDamage = 25
	snowball.DamageFalloff = 0
	snowball.DamageInnerRadius = 200
	snowball.DamageOuterRadius = 200
	snowball.ThrowForce = 5000
	]]

	snowball.TimeToExplode = 100
	snowball.BaseDamage = 25
    snowball.MinimumDamage = 25
    snowball.DamageFalloff = 0
    snowball.DamageInnerRadius = 200
    snowball.DamageOuterRadius = 200
	snowball.ThrowForce = 5000

	snowball:SetValue("Character", character)
	snowball:Subscribe("Hit", bind(self.m_OnSnowballHit, snowball))
	snowball:Subscribe("Throw", bind(self.m_OnSnowballThrow, snowball))
	character:PickUp(snowball)
	return snowball
end

function SnowballFight:OnSnowballHit(snowball, intensity)
	if snowball:IsValid() then
		snowball:Explode()
	end
end

function SnowballFight:OnSnowballThrow(snowball)
	if snowball:GetValue("Character") then
		Timer:SetTimeout(500, self.m_RespawnSnowball, {snowball:GetValue("Character")})
	end
end

function SnowballFight:RespawnSnowball(character)
	self:GiveSnowball(character)
	return false
end
