import React, { FC, useEffect } from 'react';
import { AppSetBlurred } from '../Stores/App/actions';
import { ScoreboardSetPlayers, ScoreboardSetTeams, ScoreboardSetVisible, ScoreboardUpdateConfig } from '../Stores/Scoreboard/actions';
import { useAppDispatch } from '../Stores/store';

declare var EventsWrapper: any;

const ScoreboardEvents: FC = () => {
	const dispatch = useAppDispatch();

	useEffect(() => {
		if(typeof EventsWrapper !== 'undefined') {
			EventsWrapper.Subscribe('ScoreboardSetVisible', (visible: boolean) => {
				dispatch(ScoreboardSetVisible(visible));
				dispatch(AppSetBlurred(visible));
			});

			EventsWrapper.Subscribe('ScoreboardSetPlayers', (players: string) => {
				dispatch(ScoreboardSetPlayers(JSON.parse(players)));
			});

			EventsWrapper.Subscribe('ScoreboardSetTeams', (teams: string) => {
				dispatch(ScoreboardSetTeams(JSON.parse(teams)));
			});

			EventsWrapper.Subscribe('ScoreboardUpdateConfig', (config: string) => {
				dispatch(ScoreboardUpdateConfig(JSON.parse(config)));
			});
		}

	}, [dispatch]);

    return <div></div>;
};

export default ScoreboardEvents;
