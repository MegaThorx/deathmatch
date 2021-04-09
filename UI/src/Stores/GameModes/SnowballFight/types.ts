export const SNOWBALL_FIGHT_HEART_UPDATE_HEART = 'SNOWBALL_FIGHT_HEART_UPDATE_HEART';

export interface SnowballFightHeart {
	heart: number,
	heartCount: number
}

export interface SnowballFightState {
	heart: SnowballFightHeart
}

interface SnowballFightUpdateHeartAction {
  type: typeof SNOWBALL_FIGHT_HEART_UPDATE_HEART,
  payload: SnowballFightHeart
}

export type SnowballFightActionTypes = SnowballFightUpdateHeartAction
