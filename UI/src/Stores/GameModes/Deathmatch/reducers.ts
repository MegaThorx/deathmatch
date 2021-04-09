import { Reducer } from 'redux';
import { DeathmatchState, DeathmatchActionTypes, DEATHMATCH_UPDATE_TIME, DEATHMATCH_UPDATE_SCORE } from './types';

const initialState: DeathmatchState = {
	scores: [],
	timeRemaining: 0
}

export const DeathmatchReducer: Reducer<DeathmatchState, DeathmatchActionTypes> = (state: DeathmatchState = initialState, action: DeathmatchActionTypes) => {
	switch (action.type) {
		case DEATHMATCH_UPDATE_TIME:
			return {
				...state,
				timeRemaining: action.payload
			}
		case DEATHMATCH_UPDATE_SCORE:
			return {
				...state,
				scores: action.payload
			}
		default:
			return state
	}
}
