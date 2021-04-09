export const DEATHMATCH_UPDATE_SCORE = 'DEATHMATCH_UPDATE_SCORE';
export const DEATHMATCH_UPDATE_TIME = 'DEATHMATCH_UPDATE_TIME';

export interface DeathmatchScore {
	name: string,
	score: number
}

export interface DeathmatchState {
	timeRemaining: number,
	scores: DeathmatchScore[]
}

interface DeathmatchUpdateScoreAction {
  type: typeof DEATHMATCH_UPDATE_SCORE,
  payload: DeathmatchScore[]
}

interface DeathmatchUpdateTimeAction {
  type: typeof DEATHMATCH_UPDATE_TIME,
  payload: number
}

export type DeathmatchActionTypes = DeathmatchUpdateScoreAction | DeathmatchUpdateTimeAction
