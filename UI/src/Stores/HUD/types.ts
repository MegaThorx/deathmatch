export const UPDATE_HEALTH = 'UPDATE_HEALTH';
export const UPDATE_WEAPON = 'UPDATE_WEAPON';
export const UPDATE_COUNTDOWN = 'UPDATE_COUNTDOWN';
export const ADD_KILL_FEED_ENTRY = 'ADD_KILL_FEED_ENTRY';
export const REMOVE_KILL_FEED_ENTRY = 'REMOVE_KILL_FEED_ENTRY';
export const SET_VISIBLE_SCORE_FEED = 'SET_VISIBLE_SCORE_FEED';
export const ADD_KILL_SCORE_FEED = 'ADD_KILL_SCORE_FEED';
export const ADD_FEED_ENTRY_SCORE_FEED = 'ADD_FEED_ENTRY_SCORE_FEED';

export interface HUDHealth {
	health: number,
	maxHealth: number
}

export interface HUDWeapon {
	ammunationEnabled: boolean,
	clip: number,
	bag: number
}

export interface HUDKillFeedEntry {
	time: number,
	text: string
}

export interface HUDCountdown {
	enabled: boolean,
	value: number
}

export interface HUDScoreFeedEntry {
	text: string,
	value: number
}

export interface HUDScoreFeedSkull {
	headshot: boolean
}

export interface HUDScoreFeed {
	visible: boolean,
	lastKill: string,
	lastKillScore: number,
	totalScore: number,
	lastUpdate: number,
	skulls: HUDScoreFeedSkull[],
	entries: HUDScoreFeedEntry[]
}


export interface HUDScoreFeedKillUpdate {
	lastKill: string,
	lastKillScore: number,
	headshot: boolean
}

export interface HUDScoreFeedEntryUpdate {
	text: string,
	value: number,
	stackAble: boolean
}


export interface HUDState {
	health: HUDHealth,
	weapon: HUDWeapon,
	countdown: HUDCountdown,
	scoreFeed: HUDScoreFeed,
	killFeed: HUDKillFeedEntry[]
}

interface HUDUpdateHealthAction {
  type: typeof UPDATE_HEALTH,
  payload: HUDHealth
}

interface HUDUpdateWeaponAction {
  type: typeof UPDATE_WEAPON,
  payload: HUDWeapon
}

interface HUDUpdateCountdownAction {
  type: typeof UPDATE_COUNTDOWN,
  payload: HUDCountdown
}

interface HUDAddKillFeedEntryAction {
  type: typeof ADD_KILL_FEED_ENTRY,
  payload: HUDKillFeedEntry
}

interface HUDRemoveKillFeedEntryAction {
  type: typeof REMOVE_KILL_FEED_ENTRY,
  payload: HUDKillFeedEntry
}

interface HUDSetVisibleScoreFeedAction {
	type: typeof SET_VISIBLE_SCORE_FEED,
	payload: boolean
}
interface HUDAddKillScoreFeedAction {
	type: typeof ADD_KILL_SCORE_FEED,
	payload: HUDScoreFeedKillUpdate
}
interface HUDAddFeedEntryScoreFeedAction {
	type: typeof ADD_FEED_ENTRY_SCORE_FEED,
	payload: HUDScoreFeedEntryUpdate
}

export type HUDActionTypes = HUDUpdateHealthAction | HUDUpdateWeaponAction | HUDUpdateCountdownAction | HUDAddKillFeedEntryAction | HUDRemoveKillFeedEntryAction | HUDSetVisibleScoreFeedAction | HUDAddKillScoreFeedAction | HUDAddFeedEntryScoreFeedAction
