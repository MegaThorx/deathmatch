import { Reducer } from 'redux';
import { GameModeState, GameModeActionTypes, GAME_MODE_UPDATE } from './types';

const initialState: GameModeState = {
	gameMode: ''
}

export const GameModeReducer: Reducer<GameModeState, GameModeActionTypes> = (state: GameModeState = initialState, action: GameModeActionTypes) => {
	switch (action.type) {
		case GAME_MODE_UPDATE:
			return {
				...state,
				gameMode: action.payload
			}
		default:
			return state
	}
}
