import { Reducer } from 'redux';
import { AppActionTypes, AppState, APP_SET_BLURRED } from './types';

const initialState: AppState = {
	blurred: false
}

export const AppReducer: Reducer<AppState, AppActionTypes> = (state: AppState = initialState, action: AppActionTypes) => {
	switch (action.type) {
		case APP_SET_BLURRED:
			return {
				...state,
				blurred: action.payload
			}
		default:
			return state
	}
}
