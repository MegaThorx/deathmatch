import { SnowballFightScoreActionTypes, SnowballFightScoreEntry, SNOWBALL_FIGHT_SCORE_UPDATE } from './types'

export function snowballFightScoreUpdate(players: SnowballFightScoreEntry[]): SnowballFightScoreActionTypes {
  return {
    type: SNOWBALL_FIGHT_SCORE_UPDATE,
    payload: players
  }
}
