import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { DeathmatchScore } from '../../Stores/GameModes/Deathmatch/types';
import { RootState } from '../../Stores/store';
import './Deathmatch.css';

const Deathmatch: FC = () => {
	const state = useSelector((state: RootState) => state.Deathmatch);

	const seconds = state.timeRemaining % 60;
	const minutes = Math.floor(state.timeRemaining / 60);

	const topScores = state.scores.sort((a: DeathmatchScore, b: DeathmatchScore) => a.score > b.score ? -1 : 1).slice(0, 3);

    return (
		<div className="Deathmatch">
			<p>{minutes + ':' + ('0' + seconds).slice(-2)}</p>
			{topScores.map((entry, i) => {
				return <p key={i}>{entry.name} - {entry.score}</p>;
			})}
		</div>
	);
};

export default Deathmatch;
