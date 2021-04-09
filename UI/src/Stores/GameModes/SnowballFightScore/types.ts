export const SNOWBALL_FIGHT_SCORE_UPDATE = 'SNOWBALL_FIGHT_SCORE_UPDATE';

export interface SnowballFightScoreEntry {
	name: string,
	heart: number,
	heartCount: number,
	lastUpdate: number
}

export interface SnowballFightScoreState {
	players: SnowballFightScoreEntry[]
}

interface SnowballFightScoreUpdateAction {
  type: typeof SNOWBALL_FIGHT_SCORE_UPDATE,
  payload: SnowballFightScoreEntry[]
}

export type SnowballFightScoreActionTypes = SnowballFightScoreUpdateAction
