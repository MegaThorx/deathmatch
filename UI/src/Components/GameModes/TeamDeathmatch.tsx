import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../Stores/store';
import './TeamDeathmatch.css';

const TeamDeathmatch: FC = () => {
	const state = useSelector((state: RootState) => state.TeamDeathmatch);

	const seconds = state.timeRemaining % 60;
	const minutes = Math.floor(state.timeRemaining / 60);

    return (
		<div className="TeamDeathmatch">
			<p>{minutes + ':' + ('0' + seconds).slice(-2)}</p>
			<p>{state.scores.team1_name}: {state.scores.team1_score}</p>
			<p>{state.scores.team2_name}: {state.scores.team2_score}</p>
		</div>
	);
};

export default TeamDeathmatch;
