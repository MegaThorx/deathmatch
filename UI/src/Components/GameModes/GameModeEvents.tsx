import React, { FC, useEffect } from 'react';
import { useSelector } from 'react-redux';
import { gameModeUpdate } from '../../Stores/GameModes/actions';
import { deathmatchUpdateScore, deathmatchUpdateTime } from '../../Stores/GameModes/Deathmatch/actions';
import { snowballFightUpdateHeart } from '../../Stores/GameModes/SnowballFight/actions';
import { snowballFightScoreUpdate } from '../../Stores/GameModes/SnowballFightScore/actions';
import { teamDeathmatchUpdateScore, teamDeathmatchUpdateTime } from '../../Stores/GameModes/TeamDeathmatch/actions';
import { RootState, useAppDispatch } from '../../Stores/store';

declare var Events: any;

const GameModeEvents: FC = () => {
	const dispatch = useAppDispatch();
	const state = useSelector((state: RootState) => state.Deathmatch);

	useEffect(() => {
		if(typeof Events !== 'undefined') {
			Events.Subscribe('GameModeUpdate', (gameMode: string) => {
				dispatch(gameModeUpdate(gameMode));
			});

			Events.Subscribe('DeathmatchUpdateTime', (reaminingTime: number) => {
				dispatch(deathmatchUpdateTime(reaminingTime));
			});

			Events.Subscribe('DeathmatchUpdateScore', (scores: string) => {
				dispatch(deathmatchUpdateScore(JSON.parse(scores)));
			});

			Events.Subscribe('TeamDeathmatchUpdateTime', (reaminingTime: number) => {
				dispatch(teamDeathmatchUpdateTime(reaminingTime));
			});

			Events.Subscribe('TeamDeathmatchUpdateScore', (scores: string) => {
				dispatch(teamDeathmatchUpdateScore(JSON.parse(scores)));
			});

			Events.Subscribe('SnowballFightUpdateHeart', (heart: string) => {
				dispatch(snowballFightUpdateHeart(JSON.parse(heart)));
			});

			Events.Subscribe('SnowballFightScoreUpdate', (players: string) => {
				dispatch(snowballFightScoreUpdate(JSON.parse(players)));
			});
		}

		/*
		const interval = setInterval(() => {
			var time = (new Date().getTime()) - 5000;

			for (var i = state.killFeed.length - 1; i >= 0; i--) {
				if(state.killFeed[i].time < time) {
					dispatch(removeKillFeedEntry(state.killFeed[i]));
				}
			}
		}, 250);

		return () => clearInterval(interval);
		*/
	}, [dispatch, state]);

    return <div></div>;
};

export default GameModeEvents;
