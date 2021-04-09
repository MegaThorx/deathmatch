import { GameModeActionTypes, GAME_MODE_UPDATE } from './types'

export function gameModeUpdate(gameMode: string): GameModeActionTypes {
  return {
    type: GAME_MODE_UPDATE,
    payload: gameMode
  }
}
