import { Reducer } from 'redux';
import { SnowballFightState, SnowballFightActionTypes, SNOWBALL_FIGHT_HEART_UPDATE_HEART } from './types';

const initialState: SnowballFightState = {
	heart: { heart: 0, heartCount: 3 }
}

export const SnowballFightReducer: Reducer<SnowballFightState, SnowballFightActionTypes> = (state: SnowballFightState = initialState, action: SnowballFightActionTypes) => {
	switch (action.type) {
		case SNOWBALL_FIGHT_HEART_UPDATE_HEART:
			return {
				...state,
				heart: action.payload
			}
		default:
			return state
	}
}
