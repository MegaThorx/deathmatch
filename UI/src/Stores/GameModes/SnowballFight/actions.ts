import { SnowballFightActionTypes, SnowballFightHeart, SNOWBALL_FIGHT_HEART_UPDATE_HEART } from './types'

export function snowballFightUpdateHeart(heart: SnowballFightHeart): SnowballFightActionTypes {
  return {
    type: SNOWBALL_FIGHT_HEART_UPDATE_HEART,
    payload: heart
  }
}
