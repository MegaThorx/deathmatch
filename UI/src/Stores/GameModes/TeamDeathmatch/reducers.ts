import { Reducer } from 'redux';
import { TeamDeathmatchState, TeamDeathmatchActionTypes, TEAM_DEATHMATCH_UPDATE_TIME, TEAM_DEATHMATCH_UPDATE_SCORE } from './types';

const initialState: TeamDeathmatchState = {
	scores: { team1_name: '', team1_score: 0, team2_name: '', team2_score: 0 },
	timeRemaining: 0
}

export const TeamDeathmatchReducer: Reducer<TeamDeathmatchState, TeamDeathmatchActionTypes> = (state: TeamDeathmatchState = initialState, action: TeamDeathmatchActionTypes) => {
	switch (action.type) {
		case TEAM_DEATHMATCH_UPDATE_TIME:
			return {
				...state,
				timeRemaining: action.payload
			}
		case TEAM_DEATHMATCH_UPDATE_SCORE:
			return {
				...state,
				scores: action.payload
			}
		default:
			return state
	}
}
