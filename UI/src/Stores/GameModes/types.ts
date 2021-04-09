export const GAME_MODE_UPDATE = 'GAME_MODE_UPDATE';

export interface GameModeState {
	gameMode: string
}

interface GameModeUpdateAction {
  type: typeof GAME_MODE_UPDATE,
  payload: string
}

export type GameModeActionTypes = GameModeUpdateAction
