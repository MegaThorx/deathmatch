export const SCOREBOARD_UPDATE_CONFIG = 'SCOREBOARD_UPDATE_CONFIG';
export const SCOREBOARD_SET_VISIBLE = 'SCOREBOARD_SET_VISIBLE';
export const SCOREBOARD_SET_PLAYERS = 'SCOREBOARD_SET_PLAYERS';
export const SCOREBOARD_SET_TEAMS = 'SCOREBOARD_SET_TEAMS';

export interface ScoreboardData {
	[index: string]: string;
}

export interface ScoreboardPlayer {
	name: string,
	team: number,
	ping: number,
	data: ScoreboardData
}

export interface ScoreboardTeam {
	id: number,
	maxPlayers: number,
	data: ScoreboardData
}

export interface ScoreboardConfigTeam {
	id: number,
	name: string,
	color: string,
	scoreIndex: string,
	showMaxPlayers: boolean,
}

export interface ScoreboardConfigColumn {
	name: string,
	value: string,
}

export interface ScoreboardConfig {
	columns: ScoreboardConfigColumn[],
	teams: ScoreboardConfigTeam[],
	splitTeam: boolean,
	sortBy: string,
	sortDirection: string,
}

export interface ScoreboardState {
	visible: boolean,
	config: ScoreboardConfig,
	players: ScoreboardPlayer[],
	teams: ScoreboardTeam[]
}

interface ScoreboardUpdateConfigAction {
  type: typeof SCOREBOARD_UPDATE_CONFIG,
  payload: ScoreboardConfig
}

interface ScoreboardSetVisibleAction {
  type: typeof SCOREBOARD_SET_VISIBLE,
  payload: boolean
}

interface ScoreboardSetPlayersAction {
  type: typeof SCOREBOARD_SET_PLAYERS,
  payload: ScoreboardPlayer[]
}

interface ScoreboardSetTeamsAction {
  type: typeof SCOREBOARD_SET_TEAMS,
  payload: ScoreboardTeam[]
}

export type ScoreboardActionTypes = ScoreboardUpdateConfigAction | ScoreboardSetVisibleAction | ScoreboardSetPlayersAction | ScoreboardSetTeamsAction
