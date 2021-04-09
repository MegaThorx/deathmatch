import { Reducer } from 'redux';
import { SnowballFightScoreState, SnowballFightScoreActionTypes, SNOWBALL_FIGHT_SCORE_UPDATE } from './types';

const initialState: SnowballFightScoreState = {
	players: []
}

export const SnowballFightScoreReducer: Reducer<SnowballFightScoreState, SnowballFightScoreActionTypes> = (state: SnowballFightScoreState = initialState, action: SnowballFightScoreActionTypes) => {
	switch (action.type) {
		case SNOWBALL_FIGHT_SCORE_UPDATE:
			return {
				...state,
				players: action.payload
			}
		default:
			return state
	}
}
