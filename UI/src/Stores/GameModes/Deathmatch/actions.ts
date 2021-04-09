import { DeathmatchActionTypes, DeathmatchScore, DEATHMATCH_UPDATE_SCORE, DEATHMATCH_UPDATE_TIME } from './types'

export function deathmatchUpdateTime(remainingTime: number): DeathmatchActionTypes {
  return {
    type: DEATHMATCH_UPDATE_TIME,
    payload: remainingTime
  }
}

export function deathmatchUpdateScore(scores: DeathmatchScore[]): DeathmatchActionTypes {
  return {
    type: DEATHMATCH_UPDATE_SCORE,
    payload: scores
  }
}
