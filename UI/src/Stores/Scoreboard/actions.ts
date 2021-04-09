import { ScoreboardActionTypes, ScoreboardConfig, ScoreboardPlayer, ScoreboardTeam, SCOREBOARD_SET_PLAYERS, SCOREBOARD_SET_TEAMS, SCOREBOARD_SET_VISIBLE, SCOREBOARD_UPDATE_CONFIG } from './types'

export function ScoreboardUpdateConfig(config: ScoreboardConfig): ScoreboardActionTypes {
	return {
    	type: SCOREBOARD_UPDATE_CONFIG,
    	payload: config
	}
}

export function ScoreboardSetVisible(visible: boolean): ScoreboardActionTypes {
	return {
		type: SCOREBOARD_SET_VISIBLE,
		payload: visible
	}
}

export function ScoreboardSetPlayers(players: ScoreboardPlayer[]): ScoreboardActionTypes {
	return {
		type: SCOREBOARD_SET_PLAYERS,
		payload: players
	}
}

export function ScoreboardSetTeams(teams: ScoreboardTeam[]): ScoreboardActionTypes {
	return {
		type: SCOREBOARD_SET_TEAMS,
		payload: teams
	}
}
