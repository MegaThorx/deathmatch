import React, { FC, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { HUDAddFeedEntryScoreFeed, HUDAddKillFeedEntry, HUDAddKillScoreFeed, HUDRemoveKillFeedEntry, HUDSetVisibleScoreFeed, HUDUpdateCountdown, HUDUpdateHealth, HUDUpdateWeapon } from '../../Stores/HUD/actions';
import { RootState, useAppDispatch } from '../../Stores/store';

declare var EventsWrapper: any;

const HUDEvents: FC = () => {
	const dispatch = useAppDispatch();
	const state = useSelector((state: RootState) => state.HUD);
	const killFeedTimeout = 5000;
	const scoreFeedTimeout = 5000;

	useEffect(() => {
		if(typeof EventsWrapper !== 'undefined') {
			EventsWrapper.Subscribe('UpdateHealth', (health: number, maxHealth: number) => {
				dispatch(HUDUpdateHealth(health, maxHealth));
			});

			EventsWrapper.Subscribe('UpdateWeaponAmmo', (enable: boolean, clip: number, bag: number) => {
				dispatch(HUDUpdateWeapon(enable, clip, bag));
			});

			EventsWrapper.Subscribe('UpdateCountdown', (enable: boolean, value: number) => {
				dispatch(HUDUpdateCountdown(enable, value));
			});

			EventsWrapper.Subscribe('AddKillFeedEntry', (text: string) => {
				dispatch(HUDAddKillFeedEntry(text, new Date().getTime()));
			});

			EventsWrapper.Subscribe('AddScoreFeedEntry', (text: string, value: number, stackAble: boolean) => {
				dispatch(HUDAddFeedEntryScoreFeed({text: text, value: value, stackAble: stackAble}));
			})

			EventsWrapper.Subscribe('AddScoreFeedKill', (lastKill: string, lastKillScore: number, headshot: boolean) => {
				dispatch(HUDAddKillScoreFeed({lastKill: lastKill, lastKillScore: lastKillScore, headshot: headshot}));
			})
		}

		const interval = setInterval(() => {
			let time = (new Date().getTime()) - killFeedTimeout;

			for (let i = state.killFeed.length - 1; i >= 0; i--) {
				if(state.killFeed[i].time < time) {
					dispatch(HUDRemoveKillFeedEntry(state.killFeed[i]));
				}
			}

			time = (new Date().getTime()) - scoreFeedTimeout;

			if (state.scoreFeed.visible) {
				if (state.scoreFeed.lastUpdate < time) {
					dispatch(HUDSetVisibleScoreFeed(false));
				}
			}

		}, 250);

		return () => clearInterval(interval);
	}, [dispatch, state]);

    return <div></div>;
};

export default HUDEvents;
