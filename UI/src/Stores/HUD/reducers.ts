import { Reducer } from 'redux';
import { ADD_KILL_FEED_ENTRY, SET_VISIBLE_SCORE_FEED, HUDActionTypes, HUDState, REMOVE_KILL_FEED_ENTRY, UPDATE_COUNTDOWN, UPDATE_HEALTH, UPDATE_WEAPON, ADD_KILL_SCORE_FEED, ADD_FEED_ENTRY_SCORE_FEED } from './types';

const initialState: HUDState = {
	health: { health: 0, maxHealth: 0 },
	weapon: { ammunationEnabled: false, clip: 0, bag: 0 },
	countdown: { enabled: false, value: 0 },
	scoreFeed: { visible: false, lastKill: '', lastKillScore: 0, totalScore: 0, lastUpdate: 0, skulls: [], entries: [] },
	killFeed: []
}

export const HUDReducer: Reducer<HUDState, HUDActionTypes> = (state: HUDState = initialState, action: HUDActionTypes) => {
	switch (action.type) {
		case UPDATE_HEALTH:
			return {
				...state,
				health: {
					health: action.payload.health,
					maxHealth: action.payload.maxHealth
				}
			}
		case UPDATE_WEAPON:
			return {
				...state,
				weapon: {
					ammunationEnabled: action.payload.ammunationEnabled,
					clip: action.payload.clip,
					bag: action.payload.bag
				}
			}
		case UPDATE_COUNTDOWN:
			return {
				...state,
				countdown: {
					enabled: action.payload.enabled,
					value: action.payload.value
				}
			}
		case ADD_KILL_FEED_ENTRY:
			return {
				...state,
				killFeed: state.killFeed.concat(action.payload)
			}
		case REMOVE_KILL_FEED_ENTRY:
			return {
				...state,
				killFeed: state.killFeed.filter((entry) => entry !== action.payload)
			}
		case SET_VISIBLE_SCORE_FEED:
			return {
				...state,
				scoreFeed: {
					...state.scoreFeed,
					visible: action.payload,
					totalScore: 0,
					entries: [],
					skulls: []
				}
			}
		case ADD_KILL_SCORE_FEED:
			let skulls = [...state.scoreFeed.skulls];
			skulls.unshift({headshot: action.payload.headshot});

			return {
				...state,
				scoreFeed: {
					...state.scoreFeed,
					skulls: skulls,
					lastKill: action.payload.lastKill,
					lastKillScore: action.payload.lastKillScore,
					totalScore: state.scoreFeed.totalScore + action.payload.lastKillScore,
					visible: true,
					lastUpdate: Date.now(),
				}
			}
		case ADD_FEED_ENTRY_SCORE_FEED:
			let entries = [...state.scoreFeed.entries];
			let add = true;

			if (action.payload.stackAble) {
				if (entries[0] && entries[0].text === action.payload.text) {
					entries[0] = Object.assign({}, entries[0], {value: entries[0].value + action.payload.value});
					add = false;
				}
			}

			if (add) {
				entries.unshift({text: action.payload.text, value: action.payload.value});
			}

			return {
				...state,
				scoreFeed: {
					...state.scoreFeed,
					entries: entries,
					totalScore: state.scoreFeed.totalScore + action.payload.value,
					visible: true,
					lastUpdate: Date.now(),
				}
			}
		default:
			return state
	}
}
