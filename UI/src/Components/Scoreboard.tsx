import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../Stores/store';
import './Scoreboard.css';
import MultiColumns from './Scoreboard/MultiColumns';
import OneColumn from './Scoreboard/OneColumn';
import ScoreboardEvents from './ScoreboardEvents';

interface ScoreboardProps {
}

const Scoreboard: FC<ScoreboardProps> = () => {
	const state = useSelector((state: RootState) => state.Scoreboard);

    return (
		<div className="Scoreboard">
			<ScoreboardEvents />
			<div className={'Scoreboard-inner ' + (!state.visible ? 'Scoreboard-hidden' : '')}>
				{state.config.splitTeam ? <MultiColumns /> : <OneColumn />}
			</div>
		</div>
	  );
};

export default Scoreboard;

/*

					{state.players.map((player) => {

						return <tr key={player.name}>
							<td>{player.name}</td>
							{state.config.columns.map((column) => {
								let value = '-';

								player.data.forEach((entry) => {
									if (column.name === entry.name) {
										value = entry.value;
									}
								});
								
								return <td key={column.name}>{value}</td>;
							})}
							<td>-</td>
						</tr>;
					})}
					*/