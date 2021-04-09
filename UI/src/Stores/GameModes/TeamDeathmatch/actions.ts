import { TeamDeathmatchActionTypes, TeamDeathmatchScore, TEAM_DEATHMATCH_UPDATE_SCORE, TEAM_DEATHMATCH_UPDATE_TIME } from './types'

export function teamDeathmatchUpdateTime(remainingTime: number): TeamDeathmatchActionTypes {
  return {
    type: TEAM_DEATHMATCH_UPDATE_TIME,
    payload: remainingTime
  }
}

export function teamDeathmatchUpdateScore(scores: TeamDeathmatchScore): TeamDeathmatchActionTypes {
  return {
    type: TEAM_DEATHMATCH_UPDATE_SCORE,
    payload: scores
  }
}
