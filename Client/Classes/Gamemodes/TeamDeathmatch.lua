TeamDeathmatch = inherit(BaseMode)
TeamDeathmatch.Name = "team_deathmatch"

function TeamDeathmatch:virtual_constructor()
    self.m_Name = TeamDeathmatch.Name

    self.m_UpdateUI = bind(self.UpdateUI, self)
    self.m_UpdateUITimer = Timer:SetTimeout(50, self.m_UpdateUI, {})

	self.m_PublicData["scoreTeam1"] = 0
	self.m_PublicData["scoreTeam2"] = 0
	self.m_PublicData["nameTeam1"] = ""
	self.m_PublicData["nameTeam2"] = ""

	-- {splitTeam: false, sortBy: '', sortDirection: 'DESC', columns: [{name: 'Kills', value: 'Kills'}, {name: 'Deaths', value: 'Deaths'}, {name: 'Score', value: 'Score'}]}

	local scoreboardConfig = {}
	scoreboardConfig.splitTeam = true
	scoreboardConfig.sortBy = 'Score'
	scoreboardConfig.sortDirection = 'DESC'
	scoreboardConfig.columns = {
		{name = "Kills", value = "Kills"},
		{name = "Deaths", value = "Deaths"},
		{name = "Score", value = "Score"}
	}

	scoreboardConfig.teams = {
		{id = 1, name = "Team Red", color = "#FFFFFF", scoreIndex = "score", showMaxPlayers = false},
		{id = 2, name = "Team Blue", color = "#FFFFFF", scoreIndex = "score", showMaxPlayers = false}
	}
	
	self.m_PublicDataChangeHook:Register(bind(self.ScoreboardUpdate, self))

	HUD:GetSingleton():TriggerEvent("ScoreboardUpdateConfig", JSON.stringify(scoreboardConfig))
end

function TeamDeathmatch:virtual_destructor()
    Timer:ClearTimeout(self.m_UpdateUITimer)
end

function TeamDeathmatch:ScoreboardUpdate()
	local teams = {
		{id = 1, maxPlayers = 0, data = {score = self.m_PublicData["scoreTeam1"]}},
		{id = 2, maxPlayers = 0, data = {score = self.m_PublicData["scoreTeam2"]}}
	}
	-- {id: 1, maxPlayers: 0, data: {'score': '7'}}

	HUD:GetSingleton():TriggerEvent("ScoreboardSetTeams", JSON.stringify(teams))
end

function TeamDeathmatch:RoundStart()
    BaseMode.RoundStart(self)
	HUD:GetSingleton():TriggerEvent("DeathmatchUpdateTime", self:GetRemainingTime())
end

function TeamDeathmatch:RoundEnd()
    self.m_Ending = true
    -- self:DrawWinningScreen()
end
--[[
function TeamDeathmatch:DrawWinningScreen()
    Render:ClearItems(self.m_UIGroupWinningScreenId)

	local font, textSize = 0, 40
	local text = "Team " .. (self.m_ScoreTeam1 > self.m_ScoreTeam2 and self.m_NameTeam1 or self.m_NameTeam2) .. " won the game"

	local viewport = Render:GetViewportSize()
	Render:AddText(self.m_UIGroupWinningScreenId, text, Vector2D(viewport.X / 2, viewport.Y / 2) - Vector2D(200, 0), font, textSize, Color(1, 1, 1, 1), 0, false, true, false, Vector2D(), Color(), false, Color())
end
]]

function TeamDeathmatch:UpdateUI()
    if self.m_Ending then
        return
	end

	BaseMode.UpdateUI(self)

	if self:IsRoundRunning() then
		if self.m_TimeStart ~= -1 then
			HUD:GetSingleton():TriggerEvent("TeamDeathmatchUpdateTime", self:GetRemainingTime())
		end

		local teams = {
			team1_name = self.m_PublicData["nameTeam1"],
			team2_name = self.m_PublicData["nameTeam2"],
			team1_score = self.m_PublicData["scoreTeam1"],
			team2_score = self.m_PublicData["scoreTeam2"]
		}

		HUD:GetSingleton():TriggerEvent("TeamDeathmatchUpdateScore", JSON.stringify(teams))
	end
    return true
end

function TeamDeathmatch:AddPlayer(player)
    table.insert(self.m_Players, player)
end

function TeamDeathmatch:RemovePlayer(player)
    table.removevalue(self.m_Players, player)
end
