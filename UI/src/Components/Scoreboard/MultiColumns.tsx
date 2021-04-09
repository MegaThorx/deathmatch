import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../Stores/store';
import './MultiColumns.css';

interface MultiColumnsProps {
}

const MultiColumns: FC<MultiColumnsProps> = () => {
	const state = useSelector((state: RootState) => state.Scoreboard);
	
	let teams: any = {};

	state.config.teams.map((team) => {
		teams[team.id] = [];
		return null;
	});

	[...(state.players)]
		.sort((a, b) => {
			var aField: any = a.data[state.config.sortBy] ? a.data[state.config.sortBy] : '';
			var bField: any = b.data[state.config.sortBy] ? b.data[state.config.sortBy] : '';

			if (state.config.sortDirection === 'ASC') {
				return aField > bField ? 1 : -1;
			}

			if (!isNaN(Number(aField))) {
				aField = Number(aField);
			}

			if (!isNaN(Number(bField))) {
				bField = Number(bField);
			}


			return aField > bField ? -1 : 1;
		})
		.map((player, i) => {
				if (teams[player.team]) {
					teams[player.team].push(<tr key={player.name}>
						<td>{teams[player.team].length + 1}</td>
						<td>{player.name}</td>
						{state.config.columns.map((column) => {
							let value = typeof player.data[column.name] !== 'undefined' ? player.data[column.name] : '-';
							
							return <td key={column.name}>{value}</td>;
						})}
						<td>{player.ping}</td>
					</tr>);
				}

				return null;
			}
		);


    return (
		<div className="Scoreboard-MultiColumns-row">
			{state.config.teams.map((team) => {
				return <div className="Scoreboard-MultiColumns-col">
					<div className="Scoreboard-MultiColumns-inner">

					 <span className="Scoreboard-MultiColumns-team" style={{color: team.color}}>{team.name}</span>
					 {team.scoreIndex !== '' ? <span> - <span>{state.teams.find(t => t.id === team.id)?.data[team.scoreIndex]}</span></span> : null}
					 <table>
						<thead>
							<tr>
								<th>#</th>
								<th>Name</th>
								{state.config.columns.map((column) => {
									return <th key={column.name}>{column.name}</th>;
								})}
								<th>Ping</th>
							</tr>
						</thead>
						<tbody>
							{teams[team.id]}
						</tbody>
					</table>
					</div>
				</div>;
			})}
		</div>
	  );
};

export default MultiColumns;
