import { Reducer } from 'redux';
import { ScoreboardActionTypes, ScoreboardState, SCOREBOARD_SET_PLAYERS, SCOREBOARD_SET_TEAMS, SCOREBOARD_SET_VISIBLE, SCOREBOARD_UPDATE_CONFIG } from './types';

const initialState: ScoreboardState = {
	visible: false,
	config: { columns: [], teams: [], splitTeam: false, sortBy: '', sortDirection: 'DESC' },
	players: [],
	teams: []
}

export const ScoreboardReducer: Reducer<ScoreboardState, ScoreboardActionTypes> = (state: ScoreboardState = initialState, action: ScoreboardActionTypes) => {
	switch (action.type) {
		case SCOREBOARD_UPDATE_CONFIG:
			return {
				...state,
				config: action.payload
			}
		case SCOREBOARD_SET_VISIBLE:
			return {
				...state,
				visible: action.payload
			}
		case SCOREBOARD_SET_PLAYERS:
			return {
				...state,
				players: action.payload
			}
		case SCOREBOARD_SET_TEAMS:
			return {
				...state,
				teams: action.payload
			}
		default:
			return state
	}
}
