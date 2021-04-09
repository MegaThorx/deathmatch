HUD = inherit(Singleton)

function HUD:constructor()
    --self.m_UpdateTimer = Timer:SetTimeout(50, bind(self.Render, self), {}) -- well thats not great... Maybe switch to Weapon Fire and Reload event?
    self.m_OnTick = bind(self.OnTick, self)
    self.m_OnCharacterPossess = bind(self.OnCharacterPossess, self)
	self.m_OnCharacterRespawn = bind(self.OnCharacterRespawn, self)
	self.m_OnCharacterDeath = bind(self.OnCharacterDeath, self)
    self.m_OnCharacterTakeDamage = bind(self.OnCharacterTakeDamage, self)
    self.m_OnCharacterPickUp = bind(self.OnCharacterPickUp, self)
    self.m_OnCharacterDrop = bind(self.OnCharacterDrop, self)
    self.m_OnCharacterFire = bind(self.OnCharacterFire, self)
    self.m_OnCharacterReload = bind(self.OnCharacterReload, self)
    self.m_OnAddKillFeedEntry = bind(self.OnAddKillFeedEntry, self)
    self.m_OnAddScoreFeedEntry = bind(self.OnAddScoreFeedEntry, self)
    self.m_OnAddScoreFeedKill = bind(self.OnAddScoreFeedKill, self)

    self.m_FPS = -1

    self.m_WebUI = WebUI("React", "file:///UI/React/index.html")
	self.m_WebUI:Subscribe("Ready", bind(self.OnWebUIReady, self))
	self.m_WebUIReady = false
	self.m_CachedWebUIEvents = {}

    Client:Subscribe("Tick", self.m_OnTick)

    Player.LocalPlayer:Subscribe("Possess", self.m_OnCharacterPossess)
	Events:Subscribe("HUD_AddKillFeedEntry", self.m_OnAddKillFeedEntry)
	Events:Subscribe("HUD_AddScoreFeedEntry", self.m_OnAddScoreFeedEntry)
	Events:Subscribe("HUD_AddScoreFeedKill", self.m_OnAddScoreFeedKill)
end

function HUD:destructor()
	-- Timer:ClearTimeout(self.m_UpdateTimer)
    Render:ClearItems(0)
    Render:ClearItems(1)
	Render:ClearItems(2)
	self.m_WebUI:Destroy()
	Package:Log("HUD:destructor")
end

function HUD:OnWebUIReady()
	Timer:SetTimeout(500, bind(self.OnInitialHUDUpdate, self))
end

function HUD:OnInitialHUDUpdate()
	if Player.LocalPlayer:GetControlledCharacter() then
        Package:Log("HUD:OnInitialHUDUpdate")
		self:OnCharacterPossess(Player.LocalPlayer, Player.LocalPlayer:GetControlledCharacter())
	end

	self.m_WebUIReady = true

	for _, value in ipairs(self.m_CachedWebUIEvents) do
		self:TriggerEvent(value.name, table.unpack(value.args))
	end

	return false
end

function HUD:OnCharacterPossess(player, character)
    if not character or not character:IsValid() then return end

    self:UpdateHealth(character:GetHealth(), character:GetMaxHealth())

    local picked = character:GetPicked()
	if picked then
		if picked:GetType() == "Weapon" then
			self:UpdateAmmunation(true, picked:GetAmmoClip(), picked:GetAmmoBag())
		elseif picked:GetType() == "Grenade" then
			self:UpdateAmmunation(false, 1, 0)
		end
    end

    -- Subscribe to the events - maybe replace it with hooks???

    -- Health events
    character:Subscribe("Respawn", self.m_OnCharacterRespawn)
    character:Subscribe("TakeDamage", self.m_OnCharacterTakeDamage)
    character:Subscribe("Death", self.m_OnCharacterDeath)

    -- Weapon events
    character:Subscribe("PickUp", self.m_OnCharacterPickUp)
    character:Subscribe("Drop", self.m_OnCharacterDrop)
    character:Subscribe("Fire", self.m_OnCharacterFire)
    character:Subscribe("Reload", self.m_OnCharacterReload)
end

function HUD:OnCharacterRespawn()
    local character = Player.LocalPlayer:GetControlledCharacter()
	self:UpdateHealth(character:GetHealth(), character:GetMaxHealth())
end

function HUD:OnCharacterDeath()
    local character = Player.LocalPlayer:GetControlledCharacter()
    self:UpdateHealth(0, character:GetMaxHealth())
end

function HUD:OnCharacterTakeDamage(character, damage, bone, type, fromDirection, instigator)
	-- local character = Player.LocalPlayer:GetControlledCharacter()
	local health = character:GetHealth() - damage
    self:UpdateHealth(health < 0 and 0 or health, character:GetMaxHealth())
end

function HUD:OnCharacterPickUp(object)
    if object:GetType() == "Weapon" then
        self:UpdateAmmunation(true, object:GetAmmoClip(), object:GetAmmoBag())
	elseif object:GetType() == "Grenade" then
		self:UpdateAmmunation(false, 1, 0)
	end
end

function HUD:OnCharacterDrop()
    self:UpdateAmmunation(false)
end

function HUD:OnCharacterFire(character, weapon)
    self:UpdateAmmunation(true, weapon:GetAmmoClip(), weapon:GetAmmoBag())
end

function HUD:OnCharacterReload(character, weapon)
    self:UpdateAmmunation(true, weapon:GetAmmoClip(), weapon:GetAmmoBag())
end

function HUD:OnAddKillFeedEntry(text)
    self:AddKillFeedEntry(text)
end

function HUD:OnAddScoreFeedEntry(text, value, stackAble)
    self.m_WebUI:CallEvent("AddScoreFeedEntry", {text, value, stackAble})
end

function HUD:OnAddScoreFeedKill(text, value, headshot)
    self.m_WebUI:CallEvent("AddScoreFeedKill", {text, value, headshot})
end

function HUD:UpdateHealth(health, maxHealth)
    self.m_WebUI:CallEvent("UpdateHealth", {health, maxHealth})
end

function HUD:UpdateAmmunation(enabled, clip, bag)
    self.m_WebUI:CallEvent("UpdateWeaponAmmo", {enabled, clip, bag})
end

function HUD:AddKillFeedEntry(text)
    self.m_WebUI:CallEvent("AddKillFeedEntry", {text})
end

function HUD:TriggerEvent(name, ...)
	if self.m_WebUIReady then
		self.m_WebUI:CallEvent(name, {...})
	else
		table.insert(self.m_CachedWebUIEvents, {name = name, args = {...}})
	end
end

function HUD:Update()
    --[[
    local y = 0
    Render:ClearItems(0)
    for _, player in pairs(PlayerManager:GetSingleton():GetPlayers()) do
        local text = player:GetName() .. "| Kills: " .. tostring(player:GetPublicData("Kills")) .. "| Deaths: " .. tostring(player:GetPublicData("Deaths"))
        Render:AddText(0, text, Vector2D(0, y), 0, 16, Color(1, 1, 1, 1), 0, false, false, true, Vector2D(1, 1), Color(1, 1, 1, 1), false, Color(1, 1, 1, 1))
        y = y + 20
    end
    ]]
end

function HUD:OnTick(deltaTime)
    self.m_FPS = math.floor(1 / deltaTime)
end

function HUD:Render()
    local viewPort = Render:GetViewportSize()
    if Player.LocalPlayer then
        local character = Player.LocalPlayer:GetControlledCharacter()
        self:DrawAmmunation(viewPort, character)
        self:DrawHealth(viewPort, character)
        self:DrawDebugInformation(viewPort)
    end

    return true
end

function HUD:DrawDebugInformation(viewPort, character)
    Render:ClearItems(2)
    local fontType, fontSize = 0, 12

    local lines = {}

    table.insert(lines, "Name: " .. tostring(Player.LocalPlayer:GetName()))
    table.insert(lines, "Ping: " .. tostring(Player.LocalPlayer:GetPing()))
    table.insert(lines, "FPS: " .. tostring(self.m_FPS))

    if Player.LocalPlayer:GetPublicData("Score") then
        table.insert(lines, "Score: " .. tostring(Player.LocalPlayer:GetPublicData("Score")))
    end

    local character = Player.LocalPlayer:GetControlledCharacter()
    if character then
        local location = character:GetLocation()
        table.insert(lines, "X: " .. tostring(math.floor(location.X * 100) / 100))
        table.insert(lines, "Y: " .. tostring(math.floor(location.Y * 100) / 100))
        table.insert(lines, "Z: " .. tostring(math.floor(location.Z * 100) / 100))
    else
        table.insert(lines, "X: -")
        table.insert(lines, "Y: -")
        table.insert(lines, "Z: -")
    end

    local viewPort = Render:GetViewportSize()

    for k, text in ipairs(lines) do
        local length = Render:StrLen(text, fontType, fontSize)

        Render:AddText(2, text, Vector2D(viewPort.X, 0) - Vector2D(length.X, 0) + Vector2D(-10, 10 + (length.Y + 2) * (k - 1)), fontType, fontSize, Color(1, 1, 1, 1), 0, false, false, false, Vector2D(1, 1), Color(1, 1, 1, 1), false, Color(1, 1, 1, 1))
    end
end

function HUD:DrawAmmunation(viewPort, character)
    Render:ClearItems(1)
    if character then
        local weapon = character:GetPicked()

        if weapon and weapon.GetAmmoClip then
            local fontType, fontSize = 0, 32
            local text = weapon:GetAmmoClip() .. "/" .. weapon:GetAmmoBag()
            local length = Render:StrLen(text, fontType, fontSize)

            Render:AddText(1, text, viewPort - length - Vector2D(30, 30), fontType, fontSize, Color(1, 1, 1, 1), 0, false, false, true, Vector2D(1, 1), Color(1, 1, 1, 1), false, Color(1, 1, 1, 1))
        end
    end
end

function HUD:DrawHealth(viewPort, character)
    Render:ClearItems(5)
    if character then
        local fontType, fontSize = 0, 32
        local text = character:GetHealth() .. " HP"
        local length = Render:StrLen(text, fontType, fontSize)

        Render:AddText(5, text, viewPort - length - Vector2D(0, length.Y) - Vector2D(30, 30), fontType, fontSize, Color(1, 1, 1, 1), 0, false, false, true, Vector2D(1, 1), Color(1, 1, 1, 1), false, Color(1, 1, 1, 1))
    end
end
