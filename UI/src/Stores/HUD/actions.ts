import { UPDATE_HEALTH, UPDATE_WEAPON, HUDActionTypes, HUDKillFeedEntry, ADD_KILL_FEED_ENTRY, REMOVE_KILL_FEED_ENTRY, UPDATE_COUNTDOWN, SET_VISIBLE_SCORE_FEED, HUDScoreFeedKillUpdate, ADD_KILL_SCORE_FEED, ADD_FEED_ENTRY_SCORE_FEED, HUDScoreFeedEntryUpdate } from './types'

export function HUDUpdateHealth(health: number, maxHealth: number): HUDActionTypes {
  return {
    type: UPDATE_HEALTH,
    payload: {
		health: health,
		maxHealth: maxHealth
	}
  }
}

export function HUDUpdateWeapon(ammunationEnabled: boolean, clip: number, bag: number): HUDActionTypes {
  return {
    type: UPDATE_WEAPON,
    payload: {
		ammunationEnabled: ammunationEnabled,
		clip: clip,
		bag: bag
	}
  }
}

export function HUDUpdateCountdown(enabled: boolean, value: number): HUDActionTypes {
  return {
    type: UPDATE_COUNTDOWN,
    payload: {
		enabled: enabled,
		value: value
	}
  }
}

export function HUDAddKillFeedEntry(text: string, time: number): HUDActionTypes {
	return {
		type: ADD_KILL_FEED_ENTRY,
		payload: {
			text: text,
			time: time
		}
	}
}

export function HUDRemoveKillFeedEntry(entry: HUDKillFeedEntry): HUDActionTypes {
	return {
		type: REMOVE_KILL_FEED_ENTRY,
		payload: entry
	}
}

export function HUDSetVisibleScoreFeed(state: boolean): HUDActionTypes {
	return {
		type: SET_VISIBLE_SCORE_FEED,
		payload: state
	}
}

export function HUDAddKillScoreFeed(entry: HUDScoreFeedKillUpdate): HUDActionTypes {
	return {
		type: ADD_KILL_SCORE_FEED,
		payload: entry
	}
}

export function HUDAddFeedEntryScoreFeed(entry: HUDScoreFeedEntryUpdate): HUDActionTypes {
	return {
		type: ADD_FEED_ENTRY_SCORE_FEED,
		payload: entry
	}
}
