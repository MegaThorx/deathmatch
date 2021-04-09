export const TEAM_DEATHMATCH_UPDATE_SCORE = 'TEAM_DEATHMATCH_UPDATE_SCORE';
export const TEAM_DEATHMATCH_UPDATE_TIME = 'TEAM_DEATHMATCH_UPDATE_TIME';

export interface TeamDeathmatchScore {
	team1_name: string,
	team2_name: string,
	team1_score: number,
	team2_score: number
}

export interface TeamDeathmatchState {
	timeRemaining: number,
	scores: TeamDeathmatchScore
}

interface TeamDeathmatchUpdateScoreAction {
  type: typeof TEAM_DEATHMATCH_UPDATE_SCORE,
  payload: TeamDeathmatchScore
}

interface TeamDeathmatchUpdateTimeAction {
  type: typeof TEAM_DEATHMATCH_UPDATE_TIME,
  payload: number
}

export type TeamDeathmatchActionTypes = TeamDeathmatchUpdateScoreAction | TeamDeathmatchUpdateTimeAction
