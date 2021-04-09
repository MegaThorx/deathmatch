Deathmatch = inherit(BaseMode)
Deathmatch.Name = "deathmatch"

function Deathmatch:virtual_constructor()
    self.m_Name = Deathmatch.Name

    self.m_UpdateUI = bind(self.UpdateUI, self)
	self.m_UpdateUITimer = Timer:SetTimeout(50, self.m_UpdateUI, {})
end

function Deathmatch:virtual_destructor()
    Timer:ClearTimeout(self.m_UpdateUITimer)
end

function Deathmatch:RoundStart()
    BaseMode.RoundStart(self)
	HUD:GetSingleton():TriggerEvent("DeathmatchUpdateTime", self:GetRemainingTime())
end

function Deathmatch:OnWebUIReady()
	HUD:GetSingleton():TriggerEvent("DeathmatchUpdateTime", self:GetRemainingTime())
end

function Deathmatch:RoundEnd()
    self.m_Ending = true
    -- self:DrawWinningScreen()
end
--[[
function Deathmatch:DrawWinningScreen()
    Render:ClearItems(self.m_UIGroupWinningScreenId)

    local playersWithScore = {}

    for k, player in ipairs(self.m_Players) do
        if player:IsValid() then
            table.insert(playersWithScore, {
                name = player:GetName(),
                score = player:GetPublicData("Score")
            })
        end
    end

    table.sort(playersWithScore, function(a, b) return a.score > b.score end)

    local viewport = Render:GetViewportSize()
    if playersWithScore[1] then
        local font, textSize = 0, 80
        local text = "1. " .. playersWithScore[1].name
        local size = Render:StrLen(text, font, textSize)

        Render:AddText(self.m_UIGroupWinningScreenId, text, Vector2D(viewport.X / 2, viewport.Y / 2) - Vector2D(size.X / 2, size.Y), font, textSize, Color(1, 1, 1, 1), 0, false, true, false, Vector2D(), Color(), false, Color())

        if playersWithScore[2] then
            local font, textSize = 0, 60
            local text = "2. " .. playersWithScore[2].name
            local size = Render:StrLen(text, font, textSize)

            Render:AddText(self.m_UIGroupWinningScreenId, text, Vector2D(viewport.X / 2, viewport.Y / 2) - Vector2D(size.X / 2, -10), font, textSize, Color(1, 1, 1, 1), 0, false, true, false, Vector2D(), Color(), false, Color())

            if playersWithScore[3] then
                local heightOffset = (10 + size.Y) * -1
                local font, textSize = 0, 40
                local text = "3. " .. playersWithScore[3].name
                local size = Render:StrLen(text, font, textSize)

                Render:AddText(self.m_UIGroupWinningScreenId, text, Vector2D(viewport.X / 2, viewport.Y / 2) - Vector2D(size.X / 2, heightOffset + -10), font, textSize, Color(1, 1, 1, 1), 0, false, true, false, Vector2D(), Color(), false, Color())
            end
        end
    end
end
]]
function Deathmatch:UpdateUI()
    if self.m_Ending then
        return
    end

    if self.m_TimeStart ~= -1 then
   		HUD:GetSingleton():TriggerEvent("DeathmatchUpdateTime", self:GetRemainingTime())
    end

    local playersWithScore = {}

    for k, player in ipairs(self.m_Players) do
        if player:IsValid() then
            table.insert(playersWithScore, {
                name = player:GetName(),
                score = player:GetPublicData("Score") and player:GetPublicData("Score") or 0
            })
        end
    end

	HUD:GetSingleton():TriggerEvent("DeathmatchUpdateScore", JSON.stringify(playersWithScore))
    return true
end

function Deathmatch:AddPlayer(player)
    table.insert(self.m_Players, player)
end

function Deathmatch:RemovePlayer(player)
    table.removevalue(self.m_Players, player)
end
