import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../Stores/store';
import './GameModes.css';
import Deathmatch from './GameModes/Deathmatch';
import SnowballFightScore from './GameModes/SnowballFightScore';
import TeamDeathmatch from './GameModes/TeamDeathmatch';

const GameModes: FC = () => {
	const state = useSelector((state: RootState) => state.GameMode);

	let gameMode = <></>;

	if (state.gameMode === 'deathmatch') {
		gameMode = <Deathmatch />;
	} else if (state.gameMode === 'team_deathmatch') {
		gameMode = <TeamDeathmatch />;
	} else if (state.gameMode === 'snowball_fight') {
		gameMode = <SnowballFightScore />;
	}

    return (
		<div className="GameModes">
			{gameMode}
		</div>
	);
};

export default GameModes;
